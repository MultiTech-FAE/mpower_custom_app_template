/*
 * main.c
 *  Example mPower custom application. 
 *
 *  Cross compile, package, and install.
 */

#include <syslog.h>
#include <stdarg.h>
#include <unistd.h>

//Logger identification.
#define LOG_IDENT "c_example"

//Maximum length of a configuration file path.
#define FPATH_LEN_MAX 255

/*
 * log_info()
 */
void log_info(char *format, ...) {
    va_list args;
    va_start(args, format);
    syslog (
        LOG_MAKEPRI(LOG_DAEMON, LOG_INFO),
        format,
        args
    );
    va_end(args);
}

/*
 * parse_args_strncpy()
 *  Copies string and confirms that the src string including NULL
 *  terminator fits in the destination string.
 * 
 * dst - Destination memory where string will be copied.
 * src - Memory pointing at NULL terminated string.
 * dst_sz - Memory size in bytes pointed at by dst.
 * 
 * Returns: -1 if string does not fit. Destination is empty string.
 *           0 if string fit. Destination is a null terminated string.
 *
 */
int parse_args_strncpy(char *dst, const char *src, unsigned int dst_sz) {
    int i = 0;

    assert(NULL != src);
    assert(NULL != dst);
    assert(dst_sz);

    if(dst_sz) {
        for(i = 0; i < dst_sz; ++i) {
            dst[i] = src[i];
            if(0x00 == src[i]) {
                for(++i; i < dst_sz; ++i) {
                    dst[i] = 0x00;
                }
                return 0;
            }
        }
        dst[0] = 0x00;
    }

    return -1;
}

/*
 * Reads file until lf or bufsz - 1 bytes.
 *
 * Returns:
 *  NULL terminated string in str 
 *  Size of string not including NULL terminator or -1 on error.
 *  
 *
 */
int creadln(char *str, int strsz, FILE *f) {
    char buf = 0x00;
    int  maxlen = strsz - 1;
    int  retval = 0;
    int  i = 0;

    assert(NULL != str);
    assert(strsz > 0);
    assert(NULL != f);

    for(i = 0; i < maxlen; ++i) {
        retval = fread(&buf, 1, 1, f);
        if(retval < 0) {
            
        if('\n' == buf) {
            str[i] = buf;
            ++i;
            break;
        }
    }

    return i;
}


int main(int argc, char *argv[]) {
    int  retval         = 0;
    FILE *f             = NULL;
    char fpath[BUF_LEN] = {0x00};
    char line[BUF_LEN]  = {0x00};

    openlog(LOG_IDENT, LOG_PERROR, LOG_DAEMON);
    log_info("Begin application...");

    while ((opt = getopt(argc, argv, "c")) != -1) {
        switch (opt) {
            case 'c': 
                if(0 == parse_args_strncpy(fpath, optarg, BUF_LEN)) {
                    log_info("Opening configuration file '%s'...", fpath);

                    f = fopen(fpath, "rb");
                    if(NULL != f) {
                        log_info("File open.");

                    }
                }
            default:
                fprintf(stderr, "Usage: %s [-c configuration file path] \n", argv[0]);
                exit(EXIT_FAILURE);
        }
    }

    log_info("End application.");
    return 0;
}
