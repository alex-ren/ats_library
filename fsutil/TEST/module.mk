
ifneq "$(subdirectory)" "module.mk"
  local_path := $(subdirectory)
else
  local_path := .
endif


local_target := $(local_path)/regexp_test

local_src := $(wildcard $(local_path)/*.sats) \
             $(wildcard $(local_path)/*.dats)

$(eval $(call make-ats_fsutil_program, $(local_target), $(local_src)))


