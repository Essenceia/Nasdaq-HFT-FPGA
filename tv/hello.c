# include  <vpi_user.h>

static int hello_compiletf(char*user_data)
{
      return 0;
}

static int hello_calltf(char*user_data)
{
      vpi_printf("Hello, World!\n");

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

void hello_register()
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysFunc;
      tf_data.sysfunctype  = vpiSysFuncInt;
      tf_data.tfname    = "$hello";
      tf_data.calltf    = hello_calltf;
      tf_data.compiletf = hello_compiletf;
      tf_data.sizetf    = 32;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])() = {
    hello_register,
    0
};

