# include  <vpi_user.h>
#include "tv.h"

#define AXI_TVALID_W 1
#define AXI_TKEEP_W  8
#define AXI_TDATA_W  64

tv_t * tv_s = NULL;

static int tb_compiletf(char*user_data)
{
	tv_s = tv_alloc("/home/pitchu/rtl/hft/tv/12302019.NASDAQ_ITCH50");
	if ( tv_s == NULL) return 1;
	tv_create_packet( tv_s, 1 );
    return 0;
}

static int tb_calltf(char*user_data)
{
      vpi_printf("tb, World!\n");

	vpiHandle systfref, args_iter, argh;
  struct t_vpi_value argval;
  int value;

  // Obtain a handle to the argument list
  systfref = vpi_handle(vpiSysTfCall, NULL);
  args_iter = vpi_iterate(vpiArgument, systfref);

  // Grab the value of the first argument
  argh = vpi_scan(args_iter);
  argval.format = vpiIntVal;
  vpi_get_value(argh, &argval);
  value = argval.value.integer;
  vpi_printf("VPI routine received %d\n", value);

  // Increment the value and put it back as first argument
  argval.value.integer = value + 1;
  vpi_put_value(argh, &argval, NULL, vpiNoDelay);

  // Cleanup and return
  vpi_free_object(args_iter);
  return 0;
}

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

      tf_data.type      = vpiSysFunc;
      tf_data.sysfunctype  = vpiSysFuncInt;
      tf_data.tfname    = "$tb";
      tf_data.calltf    = tb_calltf;
      tf_data.compiletf = tb_compiletf;
      tf_data.sizetf    = 73; // 1 + 8 + 64 = 73
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])() = {
    tb_register,
    0
};

