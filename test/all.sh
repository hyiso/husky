set -e

rm -fr /tmp/husky && cp -r ./ /tmp/husky

sh test/1_default.sh
sh test/2_in-sub-dir.sh
sh test/3_from-sub-dir.sh
sh test/4_not-git-dir.sh
sh test/5_set-add.sh
sh test/6_command_not_found.sh
