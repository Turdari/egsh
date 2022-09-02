

udev_info_devfile()
{
    echo "${FUNCNAME[@]}"
    udevadm info -n $@

}
