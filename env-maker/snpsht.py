def restore(conn,domain,snapname):
    d=conn.lookupByName(domain)
    s=d.snapshotLookupByName(snapname)
    d.revertToSnapshot(s)
    
