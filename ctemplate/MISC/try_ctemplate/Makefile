
# modify here
CTEMPLATE_PATH := $(HOME)/programs/ctemplate-2.2
CTEMPLATE_INC := $(CTEMPLATE_PATH)/src
CTEMPLATE_LIB := $(CTEMPLATE_PATH)/.libs

TARGET=example

all: $(TARGET)

$(TARGET): example.cpp
	g++ -I$(CTEMPLATE_INC) $^ -L$(CTEMPLATE_LIB) -l:libctemplate_nothreads.a -o $(TARGET) 

test:
	./$(TARGET)

.PHONY: clean

clean:
	rm -rf *.o
	rm -rf $(TARGET)



