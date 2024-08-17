{
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /srv/nfs           *(insecure,sync,crossmnt,no_subtree_check,ro,fsid=0)
    /srv/nfs/quitzka   *(insecure,sync,crossmnt,no_subtree_check,nohide)
  '';
}
