extern crate core;
extern crate libc;

#[macro_use]
extern crate lazy_static;

use libc::{c_void, c_int, c_char, c_float};
use core::plugin_handler::*;
use std::ptr;

#[repr(C)]
struct Context<'a> {
    plugin_handler: PluginHandler<'a>,
}

fn main() {
    let search_paths = vec!["t2-output/macosx-clang-debug", "target-debug"];

    let mut context = Box::new(Context {
        plugin_handler: PluginHandler::new(search_paths),
    });

    context.plugin_handler.add_plugin(&"breakpoints_plugin".to_string());

    unsafe {
        // this is kinda ugly but we have no good way to pass this around
        bgfx_set_context(&mut *context);
        prodbg_main(0, ptr::null())
    }

    //println!("Hello, world!");
}

///
/// 
///
///

extern {
    fn prodbg_main(argc: c_int, argv: *const c_char);

    fn bgfx_create();
    fn bgfx_destroy();

    fn bgfx_create_window(window: *const c_void, width: c_int, height: c_int);
    fn bgfx_pre_update();
    fn bgfx_post_update();

    fn bgfx_get_ui_funcs() -> *const c_void;

    fn bgfx_imgui_begin(show: c_int);
    fn bgfx_imgui_end();

    fn bgfx_imgui_set_window_pos(x: c_float, y: c_float);
    fn bgfx_imgui_set_window_size(x: c_float, y: c_float);

    fn bgfx_set_context(context: *mut Context); 
    fn bgfx_get_context() -> *mut Context;
}

///
/// These are calls coming from the C/C++ Code
///

#[no_mangle]
pub extern fn prodbg_create(window: *const c_void, width: c_int, height: c_int) {
    unsafe { 
        bgfx_create(); 
        bgfx_create_window(window, width, height);
    }
}

#[no_mangle]
pub unsafe extern fn prodbg_timed_update() {
    let context = bgfx_get_context();
    let t = &mut (*context);

    bgfx_pre_update();
    bgfx_post_update();
}

#[no_mangle]
pub extern fn prodbg_application_launched() {
}

#[no_mangle]
pub extern fn prodbg_event(event_id: c_int) {
    println!("event {}", event_id);
}

#[no_mangle]
pub extern fn prodbg_destroy() {
    unsafe {
        bgfx_destroy();
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#[no_mangle]
pub extern fn main_run() { }

#[no_mangle]
pub extern fn main_shutdown() { }






