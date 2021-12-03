#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2019 solidity contributors.
#------------------------------------------------------------------------------

set -e

source scripts/common.sh
source test/externalTests/common.sh

verify_input "$1"
SOLJSON="$1"

function compile_fn { npm run build; }
function test_fn { npm test; }

function gnosis_safe_test
{
    local repo="https://github.com/gnosis/safe-contracts.git"
    local branch=main
    local config_file="hardhat.config.ts"
    local config_var=userConfig
    local min_optimizer_level=2
    local max_optimizer_level=3

    local selected_optimizer_levels
    selected_optimizer_levels=$(circleci_select_steps "$(seq "$min_optimizer_level" "$max_optimizer_level")")
    print_optimizer_levels_or_exit "$selected_optimizer_levels"

    setup_solcjs "$DIR" "$SOLJSON"
    download_project "$repo" "$branch" "$DIR"

    # NOTE: The patterns below intentionally have hard-coded versions.
    # When the upstream updates them, there's a chance we can just remove the regex.
    sed -i 's|"@gnosis\.pm/mock-contract": "\^4\.0\.0"|"@gnosis.pm/mock-contract": "github:solidity-external-tests/mock-contract#master_080"|g' package.json
    sed -i 's|"@openzeppelin/contracts": "\^3\.4\.0"|"@openzeppelin/contracts": "^4.0.0"|g' package.json

    neutralize_package_lock
    neutralize_package_json_hooks
    force_hardhat_compiler_binary "$config_file" "$SOLJSON"
    force_hardhat_compiler_settings "$config_file" "$min_optimizer_level" "$config_var"
    npm install

    replace_version_pragmas

    for level in $selected_optimizer_levels; do
        hardhat_run_test "$config_file" "$level" compile_fn test_fn "$config_var"
    done
}

external_test Gnosis-Safe gnosis_safe_test
