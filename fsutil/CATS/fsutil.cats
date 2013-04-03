
#ifndef ATSLIB_FSUTIL_CATS
#define ATSLIB_FSUTIL_CATS

#include <dirent.h>

// #include <limits.h>
#include <stdlib.h>

// #include <sys/types.h>
#include <sys/stat.h>
// #include <unistd.h>

#include <string.h>

ATSinline()
ats_int_type
ats_fsutil_opendir(ats_ptr_type name, ats_ref_type dir)
{
    DIR * pd = opendir(name);
    if (NULL == pd)
    {
        return -1;
    }
    else
    {
        *((DIR **) dir) = pd;
        return 0;
    }
}
    

ATSinline()
ats_int_type
ats_fsutil_closedir(DIR *d)
{
    return closedir(d);
}


ATSinline()
ats_int_type
ats_fsutil_readdir(DIR *d, ats_ref_type df)
{
    struct dirent * pdirent = readdir(d);
    if (NULL != pdirent)
    {
        *(struct dirent **)df = pdirent;
        return 0;
    }
    else
    {
        return -1;
    }
}

ATSinline()
ats_ptr_type
ats_fsutil_get_name(struct dirent *pdirent)
{
    int n = strlen(pdirent->d_name);

    char *des = (char*)ATS_MALLOC(n + 1) ;
    des[n] = '\0';
    memcpy(des, pdirent->d_name, n);
    return (ats_ptr_type)des;
}

ATSinline()
ats_bool_type
ats_fsutil_dirent_isfile(struct dirent *pdirent)
{
    return DT_REG == pdirent->d_type;
}

ATSinline()
ats_bool_type
ats_fsutil_dirent_isdir(struct dirent *pdirent)
{
    return DT_DIR == pdirent->d_type;
}

ATSinline()
ats_int_type
ats_fsutil_realpath(ats_ptr_type path, ats_ref_type resolved)
{
    char *res = realpath((char *)path, NULL);
    if (NULL == res)
    {
        return -1;
    }
    else
    {
        int n = strlen(res);
        char *des = (char*)ATS_MALLOC(n + 1) ;
        des[n] = '\0';
        memcpy(des, res, n);
        free(res);

        *(char **)resolved = des;
        return 0;
    }
}
        
ATSinline()
ats_int_type
ats_fsutil_get_stat(ats_ptr_type path, ats_ref_type st)
{
    struct stat *pstat = (struct stat *)st;
    int ret = stat((char *)path, pstat);
    return ret;
}

ATSinline()
ats_bool_type
ats_fsutil_stat_isfile(ats_ref_type st)
{
    return S_ISREG(((struct stat *)st)->st_mode);
}

ATSinline()
ats_bool_type
ats_fsutil_stat_isdir(ats_ref_type st)
{
    return S_ISDIR(((struct stat *)st)->st_mode);
}

















#endif

