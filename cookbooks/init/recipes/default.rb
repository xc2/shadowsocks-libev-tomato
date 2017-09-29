
apt_update 'all' do
  action :nothing
end

execute 'dpkg --add-architecture i386' do
  not_if 'dpkg --print-foreign-architectures | grep i386'
  notifies :update, 'apt_update[all]', :immediately
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
