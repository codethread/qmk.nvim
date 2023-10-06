import ts from "typescript";
import * as tstl from "typescript-to-lua";

const plugin: tstl.Plugin = {
  beforeEmit(
    program: ts.Program,
    options: tstl.CompilerOptions,
    _emitHost: tstl.EmitHost,
    result: tstl.EmitFile[],
  ) {
    const dir = program.getCurrentDirectory();
    const target = options.outDir;
    if (!target) {
      throw new Error("please set an outDir in tsconfig");
    }
    const LUA_PREFIX = target
      .replace(dir, "")
      .replace(/\\/g, "/")
      .replaceAll(/\//g, ".")
      .replace(".lua.", "");

    for (const file of result) {
      const REQUIRE_PATH_REGEX = /require\("(.+)"\)/g;
      file.code = file.code.replaceAll(
        REQUIRE_PATH_REGEX,
        (match, path: unknown) => {
          if (typeof path !== "string") {
            return match;
          }

          return `require("${LUA_PREFIX}.${path}")`;
        },
      );
    }
  },
};

export default plugin;
