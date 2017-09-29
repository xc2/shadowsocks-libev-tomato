directory '/home/vagrant/CACHE' do
  owner 'vagrant'
  group 'vagrant'
  mode 0755
  action :create
end

execute 'dpkg --add-architecture i386'

apt_update 'update' do
  action :periodic
end

package %w(
  build-essential
  gcc-multilib
  lib32z1
  lib32ncurses5
  lib32bz2-1.0
  lib32stdc++6
  libtool
  autoconf
  git
  libelf1:i386
)
