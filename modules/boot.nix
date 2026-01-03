{ ... }: {
  boot.loader.raspberryPi.bootloader = "kernel";
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = false;
  boot.tmp.tmpfsSize = 100;
}
