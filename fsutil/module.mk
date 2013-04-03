
ifneq "$(subdirectory)" "module.mk"
  local_path := $(subdirectory)
else
  local_path := .
endif

local_lib_name := atsfsutil

local_target := $(local_path)/lib$(local_lib_name).a

local_src := $(wildcard $(local_path)/SATS/*.sats) \
             $(wildcard $(local_path)/DATS/*.dats)

$(eval $(call make-library, $(local_target), $(local_src)))


