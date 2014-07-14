import libvirt
import env
import snpsht

def restore(conn,env):
    """Get list of domains and snapshots of them
    restore domains to shanpshots
    """
    for d, s in env:
        snpsht.restore(conn,d,s)
    

def connect(url):
    try:
        c = libvirt.open(url)
    except:
        print 'Failed to connect to {}'.format(url)
        return None
    return c


def make_env(name,url="qemu:///system",fl="env.json"):
    conn = connect(url)
    wrk = env.restore(name,fl)
    restore(conn,wrk)
    return 0

