CC = nvcc
NAME = estimate
OBJS = ${NAME}.o
DFLS = DFLS
CFLAGS = -O2 -I${DFLS}
LDFLAGS = -L${DFLS}

default: ${NAME}

clean:
	rm -f *.o ${NAME} *.diff

${NAME}: ${NAME}.o
	${CC} ${LDFLAGS} $< -o $@ -lnewuoa_h
${NAME}.o: ${NAME}.cu
	${CC} $(CFLAGS) -c $< -o $@
