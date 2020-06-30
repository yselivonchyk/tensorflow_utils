from inspect import getframeinfo, stack
def debuginfo(msg=None):
    caller = getframeinfo(stack()[2][0])
    callee = getframeinfo(stack()[1][0]).function
    print("%s:%d called %s" % (caller.filename, caller.lineno, callee), msg)


def debuginfo_full(msg=None):
    for frame in stack():
        caller = getframeinfo(frame[0])
        print("%s:%d" % (caller.filename, caller.lineno), msg)
        print(caller.code_context[0])


def debuginfo_wrap(func):
    def inner(*args, **kwargs):
        caller = getframeinfo(stack()[2][0])
        callee = getframeinfo(stack()[1][0]).function

        res = func(*args, **kwargs)

        print("Wrapper: %s:%d called %s. Result: %s" % (caller.filename, caller.lineno, callee, str(res)))
        return res

    return inner
