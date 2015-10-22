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

def configure(cnf):
    from waflib.Tools.compiler_c import c_compiler

    cnf.check_waf_version(mini='1.8.14')

    # use clang as compiler
    if cnf.options.clang:
        c_compiler['linux'] = ['clang']

    if cnf.options.debug:
        cnf.env.CFLAGS = ['-fsanitize=address']
        cnf.env.LINKFLAGS = ['-fsanitize=address']

    cnf.load('gnu_dirs compiler_c vala glib2')
