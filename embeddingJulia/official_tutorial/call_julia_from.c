#include <julia.h>
JULIA_DEFINE_FAST_TLS() // only define this once, in an executable (not in a shared library) if you want fast code.


void evaluate_julia_scripts(){
    jl_eval_string("x=3");
    jl_eval_string("y = -10; z=x+y; @show z");
}

void evaluate_julia_package(){
    jl_eval_string("using Pkg; Pkg.add(\"UnicodePlots\");using UnicodePlots");
    jl_eval_string("println(lineplot(1:100, sin.(range(0, stop=2π, length=100))))");
}

double get_float64(double x) {
    jl_value_t *argument = jl_box_float64(2.0);
    jl_function_t *func = jl_get_function(jl_base_module, "sqrt");
    jl_value_t *ret = jl_call1(func, argument);
    double unboxed = jl_unbox_float64(ret);
    return unboxed;
}

void array_example(size_t sz) {
    jl_value_t* array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);
    jl_array_t* x          = jl_alloc_array_1d(array_type, sz);
    double *xData = (double*)jl_array_data(x);

    printf("allocate\n");
    for (size_t i = 0; i < jl_array_len(x); i++) {
        xData[i] = i;
    }
    for (size_t i = 0; i < jl_array_len(x); i++) {
        printf("xData[%zu]=%f\n", i, xData[i]);
    }
    jl_function_t *func  = jl_get_function(jl_base_module, "reverse");
    jl_array_t *y = (jl_array_t*)jl_call1(func, (jl_value_t*)x);
    printf("print result\n");
    double* yData = (double*)jl_array_data(y);
    for (size_t i = 0; i < jl_array_len(y); i++) {
        printf("yData[%zu]=%f\n", i, yData[i]);
    }
}

void matrix_example(size_t row, size_t col) {
    // Create 2D array of float64 type
    jl_value_t *array_type = jl_apply_array_type(jl_float64_type, 2);
    jl_array_t *x  = jl_alloc_array_2d(array_type, row, col);

    jl_function_t *func  = jl_get_function(jl_base_module, "println");

    // Get array pointer
    double *p = (double*)jl_array_data(x);
    // Get number of dimensions
    int ndims = jl_array_ndims(x);
    // Get the size of the i-th dim
    size_t rows = jl_array_dim(x, 0);
    size_t cols = jl_array_dim(x, 1);

    // Fill array with data
    for (size_t r = 0; r < rows; r++) {
        for (size_t c = 0; c < cols; c++) {
            double value = c + cols * r;
            p[r + rows * c] = value;
            printf("p[%zu,%zu]=%f\n", 1 + r, 1 + c, value);
        }
    }
    (void*)jl_call1(func, (jl_value_t*)x);
}

int main(int argc, char *argv[])
{
    /* required: setup the Julia context */
    jl_init();

    /* run Julia commands */
    evaluate_julia_scripts();
    evaluate_julia_package();
    printf("%f\n", get_float64(2.0));
    array_example(15);
    matrix_example(10, 5);
    /* strongly recommended: notify Julia that the
         program is about to terminate. this allows
         Julia time to cleanup pending write requests
         and run all finalizers
    */
    jl_atexit_hook(0);
    return 0;
}
