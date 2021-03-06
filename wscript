#! /usr/bin/env python
# encoding: utf-8

VERSION = '0.1'
APPNAME = 'gapam'

top = '.'
out = 'build'

def options(opt):
    opt.load('gnu_dirs compiler_c vala glib2')

    opt.add_option('--clang', action='store_true', default=False, help='Use clang as compiler')
    opt.add_option('--debug', action='store_true', default=False, help='pass debug options to compiler')
    opt.add_option('--debug-as', action='store_true', default=False, help='pass address sanitizer option to compiler and linker (clang-only)')

def configure(cnf):
    from waflib.Tools.compiler_c import c_compiler

    cnf.check_waf_version(mini='1.8.14')

    # use clang as compiler
    if cnf.options.clang:
        c_compiler['linux'] = ['clang']

    cnf.load('gnu_dirs compiler_c vala glib2')

    cnf.check(lib='m', uselib_store='M', mandatory=True)
    cnf.check_cfg(package='gtk+-3.0', uselib_store='GTK', args='--cflags --libs', mandatory=True)
    cnf.check_cfg(package='gmodule-export-2.0', uselib_store='GMODULE', args='--libs', mandatory=True)
    cnf.check_cfg(package='libarchive', uselib_store='ARCHIVE', args='--libs', mandatory=True)

    cnf.recurse('src')

def build(bld):
    bld.recurse('src')
