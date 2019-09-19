CC = nvcc
NAME = estimate
OBJS = ${NAME}.o
DFLS = ../../../Algorithms/DFLS
CFLAGS = -O2 -I${DFLS}
LDFLAGS = -L${DFLS}

default: ${NAME}
test: test-code

clean:
	rm -f *.o ${NAME} ${NAME}-test *.diff

very-clean: clean
	rm -f *.out

${NAME}: ${NAME}.o
	${CC} ${LDFLAGS} $< -o $@ -lnewuoa_h
${NAME}.o: ${NAME}.cu
	${CC} $(CFLAGS) -UTESTING -c $< -o $@

# Rule to produce output of tests (the exponential notation uses a 'D' in
# FORTRAN, an 'E' in C, so we have to filter this).
%.out: %
	srun --gres=gpu:4 ./$< | sed 's/\([0-9]\)E\([-+]\?[0-9]\)/\1D\2/g' > $@

${NAME}-test: ${NAME}-test.o
	${CC} ${LDFLAGS} $< -o $@ -lnewuoa_h
${NAME}-test.o: ${NAME}.cu
	${CC} $(CFLAGS) -DTESTING -c $< -o $@

test-code: ${NAME}-test.out ${NAME}-orig.out
	@if diff $^ >test.diff; then \
	    /bin/echo -e "\e[1;32mtest successful\e[0;39;49m"; \
	else \
	    /bin/echo -e "\e[1;31mtest failed (see file test.diff)\e[0;39;49m"; \
	fi; \
