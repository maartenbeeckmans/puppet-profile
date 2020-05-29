class profile::storage (
  Boolean $manage_ceph = false,
)
{
  if manage_ceph {
    include ::profile::storage::ceph
  }
}
