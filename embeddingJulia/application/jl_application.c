#include<julia.h>
#include <stdio.h>

void initialize() {
    jl_init();
}

void finalize() {
    jl_atexit_hook(0);
}

void using_Rotations() {
    /*
    Technically, you can include your julia script.
    Note that, you can't use jl_eval_string("include(\"external.jl\")")
    use "Base.include(Main, \"external.jl\")" instead
    See https://github.com/JuliaLang/julia/issues/28825
    */
    jl_eval_string("Base.include(Main, \"external.jl\")");
    jl_eval_string("@show xxx");
}

int rot_z(double* arr, double theta, double x, double y, double z) {
    char eq[256];
    sprintf(eq, "rotateZ(%lf,Float64[%lf,%lf,%lf])", theta, x, y, z);
    jl_value_t *rotz = jl_eval_string(eq);
    double* ret = (double*)jl_array_data(rotz);
    for (int i = 0; i < 3; ++i)
    {
        arr[i] = ret[i];
    }
    return 0;
}

