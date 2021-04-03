#!/bin/bash 

# Force Zenity Status message box to always be on top.


(
# =================================================================
echo "# Running First Task." ; sleep 2
# Command for first task goes on this line.

# =================================================================
echo "25"
echo "# Running Second Task." ; sleep 2
# Command for second task goes on this line.

# =================================================================
echo "50"
echo "# Running Third Task." ; sleep 2
# Command for third task goes on this line.

# =================================================================
echo "75"
echo "# Running Fourth Task." ; sleep 2
# Command for fourth task goes on this line.


# =================================================================
echo "99"
echo "# Running Fifth Task." ; sleep 2
# Command for fifth task goes on this line.

# =================================================================
echo "# All finished." ; sleep 2
echo "100"


) |
zenity --progress \
  --title="Progress Status" \
  --text="First Task." \
  --percentage=0 \
  --auto-close \
  --auto-kill

(( $? != 0 )) && zenity --error --text="Error in zenity command."

exit 0
