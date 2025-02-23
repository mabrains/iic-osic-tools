#!/bin/bash

set -e

export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8
export SCRIPT_DIR=/foss/tools/iic-osic

if [ ! -d "$PDK_ROOT" ]; then
    mkdir -p "$PDK_ROOT"
fi

################
# INSTALL SKY130
################

volare enable "${OPEN_PDKS_REPO_COMMIT}" --pdk sky130

# apply SPICE mode file reduction (for the variants that exist)
# add custom IIC bind keys to magicrc

if [ -d "$PDK_ROOT/sky130A" ]; then
    cd "$PDK_ROOT/sky130A/libs.tech/ngspice" || exit 1
	"$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice tt
	"$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice ss
	"$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice ff

    echo "# Custom bindkeys for IIC" 		        >> "$PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc"
    echo "source $SCRIPT_DIR/iic-magic-bindkeys" 	>> "$PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc"
fi

if [ -d "$PDK_ROOT/sky130B" ]; then
	cd "$PDK_ROOT/sky130B/libs.tech/ngspice" || exit 1
	"$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice tt
	"$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice ss
	"$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice ff

    echo "# Custom bindkeys for IIC" 		        >> "$PDK_ROOT/sky130B/libs.tech/magic/sky130B.magicrc"
    echo "source $SCRIPT_DIR/iic-magic-bindkeys" 	>> "$PDK_ROOT/sky130B/libs.tech/magic/sky130B.magicrc"
fi

##################
# INSTALL GF180MCU
##################

volare enable "${OPEN_PDKS_REPO_COMMIT}" --pdk gf180mcu

#FIXME maybe need to run spice model file reduction here as well
#FIXME need to define a magic bindkeys for gf180mcu

#FIXME remove version fg180mcuA/B until compressed pkds become available (efabless TO use gf180mcuC)
rm -rf "$PDK_ROOT"/volare/gf180mcu/versions/*/gf180mcuA
rm -rf "$PDK_ROOT"/volare/gf180mcu/versions/*/gf180mcuB
rm -rf "$PDK_ROOT"/gf180mcuA
rm -rf "$PDK_ROOT"/gf180mcuB
