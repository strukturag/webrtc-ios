#!/usr/bin/env python
#
#
# Author: Yuriy Shevchuk <yuriy@struktur.de>
# Copyright 2015, struktur AG

# This python script patches webrtc with our inhouse patches.
#



# {
# 	"name" : "<string name of the action>",
# 	"can_have_no_c_actions" : <boolean>, #by default False. Checks if r_actions array is empty and signals error if False.
# 	"actions" : [<list/array of actions to make a patch, each should be usable by subprocess.call>],
# 	"c_actions" : [<list/array of actions to cancel actions made by 'actions', each should be usable by subprocess.call>],
# 	"os_list" : [<list of os strings for which to apply this action>], example -> ["ios", "mac"], can be ommited, in this case action is applied for any os. Not implemented yet.
# },



ACTIONS = [
	{
		"name" : "Create symbolic link for quilt",
		"actions" : [
			["ln", "-s", "strukturag-inhouse/quilt_patches", "../patches"],
		],
		"c_actions" : [
			["rm", "-f", "../patches"],
		],
	},
	{
		"name" : "Apply all quilt patches",
		"actions" : [
			["quilt", "push", "-a"],
		],
		"c_actions" : [
			["quilt", "pop", "-af"],
		],
	},
	{
		"name" : "Move chromium nss and relink inhouse nss including its sqlite dependency",
		"actions" : [
			["bash", "relink-nss.sh", "relink_nss"],
		],
		"c_actions" : [
			["bash", "relink-nss.sh", "undo_relink_nss"],
		],
	},
]

# -------------------------------------------------------------------------------------------

import os
import sys
import subprocess


def apply_actions(h_actions):
	for h_action in h_actions:
		actionName = h_action.get("name", None)
		if actionName is not None:
			print actionName
		else:
			actionName = "Unnamed action at position %d" % h_actions.index(h_action)

		can_have_no_c_actions = h_action.get("can_have_no_c_actions", False)

		c_actions = h_action.get("c_actions", [])
		actions = h_action.get("actions", [])


		if len(c_actions) == 0 and len(actions) > 0 and can_have_no_c_actions == False:
			print "Error in action: " + actionName
			print ("You have not provided cancel actions and haven't set can_have_no_r_actions flag.\n"
				   "This is failed sanity check. We need to know how to cancel actions or if you know what you're doing set can_have_no_c_actions to True.")
			sys.exit(1)
		elif len(actions) == 0:
			print "Action : " + actionName + " doesn't have actions. c_actions will not be executed."
		else:
			for c_action in c_actions:
				subprocess.call(c_action)

			for action in actions:
				subprocess.call(action)
	return


def main(argv):

	currentDir = os.getcwd()
	scriptDir = os.path.dirname(os.path.realpath(sys.argv[0]))

	try:
		os.chdir(scriptDir)
	except WindowsError, OSError:
		print "Couldn't change directory to %s" % scriptDir
		sys.exit(1)

	apply_actions(ACTIONS)
	os.chdir(currentDir)





if __name__ == "__main__":
    main(sys.argv[1:])
