.SILENT:

.PHONY: run build

BUILD_DIR ?= ./build

run: build
	@output_file=$$(mktemp) || { printf "Failed to create temporary output file\n" >&2; exit 1; }; \
	$(BUILD_DIR)/Project > "$$output_file"; \
	EXIT_CODE=$$?; \
	if [ -s "$$output_file" ]; then \
	    echo "—————————————————————— Program's Output ——————————————————————"; \
	    echo; \
	    cat "$$output_file"; \
	fi; \
	rm -f "$$output_file"; \
	if [ $$EXIT_CODE -ne 0 ]; then \
	    echo; \
	    printf "\033[1;31mProgram exited with code $$EXIT_CODE\033[0m\n"; \
	    exit $$EXIT_CODE; \
	fi

build:
	echo "————————————————————————— Build Logs —————————————————————————"
	
	@printf "\nClearing existing build...                         	\033[1;33m[\033[39m1/3\033[33m]\033[0m\n"
	
	cmake -S . -B $(BUILD_DIR) -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release > /tmp/adan_build.log 2>&1 \
	    || { printf "\n\033[1;31mProgram build failed!\033[0m\n"; \
	         echo ; echo "————————————————————————— Error Logs —————————————————————————"; \
	         cat /tmp/project_build.log; \
	         echo "———————————————————————————————————————————————————————————————"; \
	         exit 1; }
	
	@printf "Re-compiling project...                            	\033[1;33m[\033[39m2/3\033[33m]\033[0m\n"
	
	cmake --build $(BUILD_DIR) > /tmp/project_build.log 2>&1 \
	    || { printf "\n\033[1;31mProgram build failed!\033[0m\n"; \
	         echo ; echo "————————————————————————— Error Logs —————————————————————————" ; echo; \
	         cat /tmp/project_build.log; \
	         echo ; echo "———————————————————————————————————————————————————————————————"; \
			 echo \
	         exit 1; }
	
	@printf "Finishing project build...                         	\033[1;33m[\033[39m3/3\033[33m]\033[0m\n"
	
	@printf "\n\033[1;32mProgram build success!\033[0m\n\n"
