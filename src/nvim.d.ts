type UVErr = Error;

interface Cb<Data> {
  (err: undefined | UVErr, data: Data): void;
}

/**
 * uv_handle_t is the base type for all libuv handle types. All API functions defined here work with any handle type.
 */
interface BaseHandle {
  /**
   * Returns true if the handle is active, false if it's inactive. What "active” means depends on the type of handle:
   * - A uv_async_t handle is always active and cannot be deactivated, except by closing it with uv.close().
   * - A uv_pipe_t, uv_tcp_t, uv_udp_t, etc. handle - basically any handle that deals with I/O - is active when it is doing something that involves I/O, like reading, writing, connecting, accepting new connections, etc.
   * - A uv_check_t, uv_idle_t, uv_timer_t, etc. handle is active when it has been started with a call to uv.check_start(), uv.idle_start(), uv.timer_start() etc. until it has been stopped with a call to its respective stop function.
   */
  is_active(): boolean;

  close(): void;
}

interface Stat {
  size: number;
}

interface Server extends BaseHandle {
  bind(ip: string, port: number): void;
  listen(port: number, cb: (e: Error | undefined) => void): void;
  read_start(cb: (e: Error | undefined, chunk: any) => void): void;
  accept(server: Server): void;
  write(chunk: any): void;
  shutdown(): void;
}

interface Timer extends BaseHandle {
  start(duration: number, interval: number, cb: Cb): void;
  stop(): void;
}

/** file descriptor, make nominal later */
type Fd = number;

/** @noSelf **/
interface UV {
  new_tcp(): Server;
  loop_configure(s: string, y: string): void;
  run(mode?: "default" | "once" | "nowait"): void;
  stop(): void;
  fs_open(path: string, f: string, n: number, cb: Cb<Fd>): void;
  fs_fstat(fileDescriptor: Fd, cb: Cb<Stat>): void;
  fs_read(fileDescriptor: Fd, size: number, n: number, cb: Cb<string>): void;
  fs_close(fileDescriptor: Fd, cb: Cb<never>): void;
  new_timer(): Timer;
  loop_mode(): string | undefined;
  loop_alive(): boolean;
  walk(cb: (handle: BaseHandle) => void): void;
}

interface IVim {
  /** pretty print just about anything */
  /** @noSelf **/
  print(...a: any[]): void;
  /** @noSelf **/
  cmd(cmd: string): void;
  loop: UV;
  json: {
    decode(str: string, arg?: any): unkownn;
  };
}
