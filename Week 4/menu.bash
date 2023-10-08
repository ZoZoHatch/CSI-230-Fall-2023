#! /bin/bash

# Storyline: Menu for admin, VPN, and Security functions

function invalid_opt() {

    echo ""
    echo "Invalid option"
    echo ""
    sleep 2
}

function menu() {

    # Clear the screen
    clear

    echo "[1] Admin Menu"
    echo "[2] Security Menu"
    echo "[3] Exit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        1) 
            admin_menu
        ;;

        2)
            security_menu
        ;;

        3) 
            exit 0
        ;;

        *)
            invalid_opt
            # Call the main menu again
            menu
        ;;
    esac
}

function admin_menu() {

    clear

    echo "[L]ist Running Processes"
    echo "[N]etwork Sockets"
    echo "[V]pn Menu"
    echo "[E]xit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        L|l) 
            ps -ef|less
        ;;

        N|n) 
            netstat -an --inet|less
        ;;

        V|v) 
            vpn_menu
        ;;

        E|e) 
            menu
        ;;

        *)
            invalid_opt           
        ;;
    esac

    # Stay in this menu until exit
    admin_menu
}

function vpn_menu() {

    clear 

    echo "[A]dd a peer"
    echo "[D]elete a peer"
    echo "[B]ack to admin menu"
    echo "[M]ain menu"
    echo "[E]xit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        A|a) 
            bash peer.bash
            tail -6 wg0.conf|less
        ;;

        D|d) 
            # Create a prompt for the user
            read -p "What's the name of the user you want to delete? " user

            # Call the manage-user.bash and pass the proper switches and arguments
            # to delete the user
            bash manage-user.bash -d -u ${user}
        ;;

        B|b) 
            admin_menu
        ;;

        M|m) 
            menu
        ;;

        E|e) 
            exit 0
        ;;

        *)
            invalid_opt            
        ;;
    esac

    # Stay in this menu until exit
    vpn_menu
}

function security_menu() {

    clear

    echo "[L]ist open network sockets"
    echo "[C]heck if any user has a UID of 0 (sans root)"
    echo "[S]ee logged in users"
    echo "[B]lock list menu"
    echo "[E]xit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        L|l) 
            netstat -an --inet|less
        ;;

        C|c) 
            
        ;;

        S|s) 
            
        ;;

        B|b) 
            blocklist_menu
        ;;

        E|e) 
            menu
        ;;

        *)
            invalid_opt           
        ;;
    esac

    # Stay in this menu until exit
    security_menu
}

function blocklist_menu() {

    clear

    echo "[I]pTable blocklist generator"
    echo "[C]isco blocklist generator"
    echo "[D]omain URL blocklist generator"
    echo "[W]indows blocklist generator"
    echo "[M]ac blocklist generator"
    echo "[B]ack to security menu"
    echo "[M]ain menu"
    echo "[E]xit"
    read -p "Please enter a choice above: " choice

    case "$choice" in

        I|i)
            bash parse-threats.bash -i
        ;;

        C|c) 
            bash parse-threats.bash -c
        ;;

        D|d) 
            bash parse-threats.bash -p
        ;;

        W|w) 
            bash parse-threats.bash -w
        ;;

        M|m)
            bash parse-threats.bash -m
        ;;

        B|b) 
            security_menu
        ;;

        M|m) 
            menu
        ;;

        E|e) 
            exit 0
        ;;

        *)
            invalid_opt           
        ;;
    esac

    # Stay in this menu until exit
    security_menu
}

menu