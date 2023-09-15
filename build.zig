const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const lib_abseil = b.addStaticLibrary(.{
        .name = "abseil-cpp",
        .target = target,
        .optimize = optimize,
    });

    const cpp_flags_all = .{"-std=c++17"};
    lib_abseil.addCSourceFiles(&cpp_files.absl_base_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_strings_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_log_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_hash_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_time_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_container_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_synchronization_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_status_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_numeric_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_crc_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_debugging_srcs, &(.{} ++ cpp_flags_all));
    lib_abseil.addCSourceFiles(&cpp_files.absl_profiling_srcs, &(.{} ++ cpp_flags_all));

    lib_abseil.addIncludePath(.{ .path = "./" });
    lib_abseil.linkLibCpp();

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib_abseil);
    //copy header files to install location

    //want this instead of b.installDirectory(install_opts) so build.zig's that use this as a dependency can use header files
    lib_abseil.installHeadersDirectoryOptions(.{
        .source_dir = .{ .path = "absl" },
        .install_dir = .header,
        .install_subdir = "absl",
        .exclude_extensions = &.{
            "cc",
            "proto",
            "bazel",
            "txt",
            "py",
        },
    });

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    //    const main_tests = b.addTest(.{
    //       .target = target,
    //      .optimize = optimize,
    // });

    //const run_main_tests = b.addRunArtifact(main_tests);

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build test`
    // This will evaluate the `test` step rather than the default, which is "install".
    //const test_step = b.step("test", "Run library tests");
    //test_step.dependOn(&run_main_tests.step);
}

pub const cpp_files = struct {
    pub const absl_base_srcs = .{
        "absl/base/internal/cycleclock.cc",
        "absl/base/internal/spinlock.cc",
        "absl/base/internal/sysinfo.cc",
        "absl/base/internal/thread_identity.cc",
        "absl/base/internal/unscaledcycleclock.cc",
        "absl/base/log_severity.cc",
        "absl/base/internal/raw_logging.cc",
        "absl/base/internal/spinlock_wait.cc",
        "absl/base/internal/low_level_alloc.cc",
        "absl/base/internal/strerror.cc",
        "absl/base/internal/throw_delegate.cc",
    };

    pub const absl_strings_srcs = .{
        "absl/strings/ascii.cc",
        "absl/strings/charconv.cc",
        "absl/strings/escaping.cc",
        "absl/strings/internal/charconv_bigint.cc",
        "absl/strings/internal/charconv_parse.cc",
        "absl/strings/internal/damerau_levenshtein_distance.cc",
        "absl/strings/internal/memutil.cc",
        "absl/strings/internal/stringify_sink.cc",
        "absl/strings/match.cc",
        "absl/strings/numbers.cc",
        "absl/strings/str_cat.cc",
        "absl/strings/str_replace.cc",
        "absl/strings/str_split.cc",
        "absl/strings/string_view.cc",
        "absl/strings/substitute.cc",
        "absl/strings/internal/ostringstream.cc",
        "absl/strings/internal/utf8.cc",
        "absl/strings/cord.cc",
        "absl/strings/cord_analysis.cc",
        "absl/strings/cord_buffer.cc",
        "absl/strings/internal/cord_internal.cc",
        "absl/strings/internal/cord_rep_btree.cc",
        "absl/strings/internal/cord_rep_btree_navigator.cc",
        "absl/strings/internal/cord_rep_btree_reader.cc",
        "absl/strings/internal/cord_rep_crc.cc",
        "absl/strings/internal/cord_rep_consume.cc",
        "absl/strings/internal/cord_rep_ring.cc",
        "absl/strings/internal/str_format/arg.cc",
        "absl/strings/internal/str_format/bind.cc",
        "absl/strings/internal/str_format/extension.cc",
        "absl/strings/internal/str_format/float_conversion.cc",
        "absl/strings/internal/str_format/output.cc",
        "absl/strings/internal/str_format/parser.cc",
        "absl/strings/internal/escaping.cc",
        "absl/strings/internal/cordz_info.cc",
        "absl/strings/internal/cordz_functions.cc",
        "absl/strings/internal/cordz_handle.cc",
    };

    pub const absl_log_srcs = .{
        "absl/log/initialize.cc",
        "absl/log/globals.cc",
        "absl/log/internal/globals.cc",
        "absl/log/internal/log_message.cc",
        "absl/log/internal/log_format.cc",
        "absl/log/internal/nullguard.cc",
        "absl/log/internal/check_op.cc",
        "absl/log/internal/log_sink_set.cc",
        "absl/log/internal/proto.cc",
        "absl/log/log_sink.cc",
        "absl/log/internal/conditions.cc",
    };

    //https://github.com/abseil/abseil-cpp/blob/29bf8085f3bf17b84d30e34b3d7ff8248fda404e/absl/synchronization/BUILD.bazel
    pub const absl_synchronization_srcs = .{
        "absl/synchronization/barrier.cc",
        "absl/synchronization/blocking_counter.cc",
        "absl/synchronization/internal/create_thread_identity.cc",
        "absl/synchronization/internal/futex_waiter.cc",
        "absl/synchronization/internal/per_thread_sem.cc",
        "absl/synchronization/internal/sem_waiter.cc",
        "absl/synchronization/internal/stdcpp_waiter.cc",
        "absl/synchronization/internal/waiter_base.cc",
        "absl/synchronization/internal/win32_waiter.cc",
        "absl/synchronization/notification.cc",
        "absl/synchronization/mutex.cc",
        "absl/synchronization/internal/graphcycles.cc",
        "absl/synchronization/internal/kernel_timeout.cc",
    };

    pub const absl_time_srcs = .{
        "absl/time/civil_time.cc",
        "absl/time/clock.cc",
        "absl/time/duration.cc",
        "absl/time/format.cc",
        "absl/time/time.cc",
        "absl/time/internal/cctz/src/civil_time_detail.cc",
        "absl/time/internal/cctz/src/time_zone_fixed.cc",
        "absl/time/internal/cctz/src/time_zone_format.cc",
        "absl/time/internal/cctz/src/time_zone_if.cc",
        "absl/time/internal/cctz/src/time_zone_impl.cc",
        "absl/time/internal/cctz/src/time_zone_info.cc",
        "absl/time/internal/cctz/src/time_zone_libc.cc",
        "absl/time/internal/cctz/src/time_zone_lookup.cc",
        "absl/time/internal/cctz/src/time_zone_posix.cc",
        "absl/time/internal/cctz/src/zone_info_source.cc",
    };

    pub const absl_hash_srcs = .{
        "absl/hash/internal/hash.cc",
        "absl/hash/internal/city.cc",
        "absl/hash/internal/low_level_hash.cc",
    };

    pub const absl_container_srcs = .{
        "absl/container/internal/raw_hash_set.cc",
    };

    pub const absl_status_srcs = .{
        "absl/status/status.cc",
        "absl/status/status_payload_printer.cc",
        "absl/status/statusor.cc",
    };

    pub const absl_numeric_srcs = .{
        "absl/numeric/int128.cc",
    };

    pub const absl_crc_srcs = .{
        "absl/crc/internal/cpu_detect.cc",
        "absl/crc/internal/crc.cc",
        "absl/crc/internal/crc_x86_arm_combined.cc",
        "absl/crc/internal/crc_memcpy_fallback.cc",
        "absl/crc/internal/crc_memcpy_x86_64.cc",
        "absl/crc/internal/crc_non_temporal_memcpy.cc",
        "absl/crc/internal/crc_cord_state.cc",
        "absl/crc/crc32c.cc",
    };

    pub const absl_debugging_srcs = .{
        "absl/debugging/stacktrace.cc",
        "absl/debugging/internal/address_is_readable.cc",
        "absl/debugging/internal/elf_mem_image.cc",
        "absl/debugging/internal/vdso_support.cc",
        "absl/debugging/symbolize.cc",
        "absl/debugging/internal/demangle.cc",
        "absl/debugging/internal/examine_stack.cc",
    };

    pub const absl_profiling_srcs = .{"absl/profiling/internal/exponential_biased.cc"};
};
