using ArgParse

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--optimize", "-O"
        arg_type = Int
        metavar = "{0,1,2,3}"
        range_tester = (x->x ∈ (0, 1, 2, 3))
        default = 2
        help = "set the optimization level"
    end
end

function main()
    parsed_args = parse_args(s)
    for (k, v) ∈ parsed_args
        show("$k => $v")
    end
end
