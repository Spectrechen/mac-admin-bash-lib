#!/usr/bin/env bats

@test "repository has a license" {
	[ -f "${BATS_TEST_DIRNAME}/../LICENSE" ]
}
