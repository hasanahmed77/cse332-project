cmake_minimum_required(VERSION 3.22)
project(MipsAssembler)

set(CMAKE_CXX_STANDARD 17)

include_directories(.)

add_executable(MipsAssembler
        finalassembler.cpp
        mips.h
        data_symbol_table.h
)
