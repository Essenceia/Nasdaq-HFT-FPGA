/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

#include "tb.h"
#include "tb_utils.h"
#include "tb_itch.h"
#include "axis.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>

#define AXI_TVALID_W 1
#define AXI_TKEEP_W  8
#define AXI_TDATA_W  64

static tv_t * tv_s = NULL;


static int tb_compiletf(char*user_data)
{
	#ifdef DEBUG
	vpi_printf("TB compile\n");
	#endif
    return 0;
}

/* called each time the associated user-defined system task/function is executed within the Verilog HDL 
 * source code. 
 * 
 * intput :
 * tready - 1  bit
 * output :
 * tvalid - 1  bit
 * tdata  - 64 bits
 * tkeep  - 8  bit
 */
static int tb_calltf(char*user_data)
{
	#ifdef DEBUG
   	vpi_printf("TB call\n");
	#endif
	assert(tv_s);
	
	uint8_t  tready, tvalid, tkeep;
	uint64_t tdata, mask64;
	uint32_t v;
	s_vpi_value tready_val, tvalid_val, tdata_val, tkeep_val;
	vpiHandle tready_h, tvalid_h, tdata_h, tkeep_h;
	vpiHandle sys;
	vpiHandle argv;
	
	sys = vpi_handle(vpiSysTfCall, 0);
	argv = vpi_iterate(vpiArgument, sys);

	// read tready	
	tready_h = vpi_scan(argv);
	assert(tready_h);
	
	tready_val.format = vpiIntVal;
	vpi_get_value(tready_h, &tready_val);
	
	tready = tready_val.value.integer;


	// tvalid
	tvalid_h = vpi_scan(argv);
	assert(tvalid_h);
	tvalid_val.format = vpiScalarVal;
	// check tready, if true prepare to send next axis payload
	if ( tready ) {
		tvalid_val.value.scalar = vpi1; // 1'b1
		tdata = tv_axis_get_next_64b(tv_s , &tkeep);
		#ifdef DEBUG
		vpi_printf("TB call : tdata %#lx tkeep %#x\n", tdata, tkeep);
		#endif
		
		tb_vpi_logic_put_64b(argv, tdata);	
		tb_vpi_logic_put_8b(argv, tkeep);	
	}else{
		tvalid_val.value.scalar = vpi0;// write 1'b0
	}
	vpi_put_value(tvalid_h, &tvalid_val, 0, vpiNoDelay);
	vpi_free_object(argv);
	return 0;
}

// returns how many bits wide our vpi return value shall be
static PLI_INT32 tb_sizetf(char*x)
{
	// tvalid : 1
	// tkeep : 8
	// tdata : 64
    return AXI_TDATA_W + AXI_TKEEP_W + AXI_TDATA_W;
}

void tb_register()
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.sysfunctype  = 0;
      tf_data.tfname    = "$tb";
      tf_data.calltf    = tb_calltf;
      tf_data.compiletf = tb_compiletf;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}


// init routine

static int tb_init_compiletf(char* path)
{
	tv_s = NULL;
	#ifdef DEBUG
	vpi_printf("TB_INIT compile\n");
	#endif
    return 0;
}

// A calltf VPI application routine shall be called each time the associated 
// user-defined system task/function is executed within the Verilog HDL 
// source code. 
static PLI_INT32 tb_init_calltf(char*user_data)
{
	#ifdef DEBUG
	vpi_printf("TB init call: opening file \n");
	#endif
	s_vpi_value value;
	char *path;	
	vpiHandle sys = vpi_handle(vpiSysTfCall, 0);
	vpiHandle argv = vpi_iterate(vpiArgument, sys);
	vpiHandle arg;
	assert(argv);

	/* Get the one and only argument, and get its string value. */
    arg = vpi_scan(argv);
    assert(arg);

    value.format = vpiStringVal;
    vpi_get_value(arg, &value);
	path = strdup(value.value.str);

	#ifdef DEBUG
	vpi_printf("TB init call: Path %s\n", path);
	#endif

	tv_s = tv_alloc(path);
	if ( tv_s == NULL) return 1;
	tv_create_packet( tv_s, 1 );
	
	#ifdef DEBUG
	vpi_printf("TB init call : end\n");
	#endif
	vpi_free_object(argv);
	return 0;
}


void tb_init_register()
{
	s_vpi_systf_data tf_init_data;
	
	tf_init_data.type      = vpiSysFunc;
	tf_init_data.sysfunctype  = vpiSysFuncInt;
	tf_init_data.tfname    = "$tb_init";
	tf_init_data.calltf    = tb_init_calltf;
	tf_init_data.compiletf = tb_init_compiletf;
	tf_init_data.sizetf    = 0;
	tf_init_data.user_data = 0;
	vpi_register_systf(&tf_init_data);
}

static int tb_itch_compiletf(char* path)
{
    return 0;
}

static PLI_INT32 tb_itch_calltf(char*user_data){
	tv_itch5_s *itch_s;
	#ifdef DEBUG
	vpi_printf("TB itch\n");
	#endif
	s_vpi_value value;
	vpiHandle sys = vpi_handle(vpiSysTfCall, 0);
	vpiHandle argv = vpi_iterate(vpiArgument, sys);
	vpiHandle arg;
	assert(argv);
	itch_s = tb_itch_fifo_pop(tv_s->itch_fifo_s);
	if ( itch_s != NULL ){
		#ifdef DEBUG
		print_tv_itch5(itch_s);
		#endif
		tb_itch_put_struct(argv, itch_s);
		free(itch_s);
	}else{
		vpi_printf("TB itch : error, no itch ptr found\n");
	}
	vpi_free_object(argv);
	return 0;
}

void tb_itch_register()
{
	s_vpi_systf_data tf_itch_data;
	
	tf_itch_data.type      = vpiSysFunc;
	tf_itch_data.sysfunctype  = vpiSysFuncInt;
	tf_itch_data.tfname    = "$tb_itch";
	tf_itch_data.calltf    = tb_itch_calltf;
	tf_itch_data.compiletf = tb_itch_compiletf;
	tf_itch_data.sizetf    = 0;
	tf_itch_data.user_data = 0;
	vpi_register_systf(&tf_itch_data);
}
static int tb_end_compiletf(char* path)
{
    return 0;
}

static PLI_INT32 tb_end_calltf(char*user_data){
	if ( tv_s != NULL)tv_free(tv_s);	
	return 0;
}

void tb_end_register()
{
	s_vpi_systf_data tf_end_data;
	
	tf_end_data.type      = vpiSysFunc;
	tf_end_data.sysfunctype  = vpiSysFuncInt;
	tf_end_data.tfname    = "$tb_end";
	tf_end_data.calltf    = tb_end_calltf;
	tf_end_data.compiletf = tb_end_compiletf;
	tf_end_data.sizetf    = 0;
	tf_end_data.user_data = 0;
	vpi_register_systf(&tf_end_data);
}


void (*vlog_startup_routines[])() = {
    tb_init_register,
    tb_end_register,
    tb_register,
	tb_itch_register,
    0
};


