CC = nvcc
NAME = estimate
DFLS = DFLS
CFLAGS = -g -I${DFLS}
LDFLAGS = -L${DFLS}

default: ${NAME}

clean:
	rm -f ${NAME}

${NAME}: ${NAME}.cu
	${CC} $(CFLAGS) ${LDFLAGS} $< -o $@ -lnewuoa_h
