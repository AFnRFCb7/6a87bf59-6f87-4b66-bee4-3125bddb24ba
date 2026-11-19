# 2415225178811784
{
    inputs = { } ;
    outputs =
        { self } :
            {
                lib =
                    { input ? x : x , output ? x : x } :
                        let
                            implementation =
                                { lib , pkgs , ... } @module :
                                    let
                                        exploded = ./node_modules.exploded ;
                                        identified = input module ;
                                        in
                                            with identified ;
                                                {
                                                    options =
                                                        {
                                                            express-package =
                                                                lib.mkOption
                                                                    {
                                                                        default =
                                                                            pkgs.runCommand
                                                                                "express"
                                                                                {
                                                                                    nativeBuildInputs =
                                                                                        [
                                                                                            (
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                input = { read-only = true ; source = exploded ; type = "bind" ; } ;
                                                                                                                output = { source = "$out" ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "command" ;
                                                                                                        post = [ ] ;
                                                                                                        runtime-inputs =
                                                                                                            { config , ... } :
                                                                                                                [
                                                                                                                    (
                                                                                                                        config.tree-serialization.implode
                                                                                                                            {
                                                                                                                                input = "/mounts/input" ;
                                                                                                                                name = "implode" ;
                                                                                                                                output = "/mounts/output" ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                implode
                                                                                                                rm --recursive --force /mounts/out/node_modules.exploded
                                                                                                            '' ;
                                                                                                        variables = { } ;
                                                                                                    }
                                                                                            )
                                                                                        ] ;
                                                                                }
                                                                                "command" ;
                                                                        type = lib.types.package ;
                                                                    } ;
                                                        } ;
                                                } ;
                            in
                                {
                                    checks = null ;
                                    implementation =
                                        if builtins.typeOf output == "lambda" then output implementation
                                        else if builtins.typeOf output == "null" then implementation
                                        else builtins.throw "8202022236499249" ;
                                    imports = [ ] ;
                                } ;
            } ;
}