#!/bin/bash

INSTALL_PATH="/usr/local/bin/Probezila"

function show_ascii_art {
    echo -e "\033[1;93m    ____             __               _ __     "
    echo -e "\033[1;93m   / __ \_________  / /_  ___  ____  (_) /___ _"
    echo -e "\033[1;93m  / /_/ / ___/ __ \/ __ \/ _ \/_  / / / / __ \`/"
    echo -e "\033[1;93m / ____/ /  / /_/ / /_/ /  __/ / /_/ / / /_/ / "
    echo -e "\033[1;93m/_/   /_/   \____/_.___/\___/ /___/_/_/\__,_/  \033[0m"
    printf "                     Tool by \033[93mH3LLKY4T \033[31mv2 \n          \033[0m \033[31m \n"
        
    echo -e " Use with caution. Developers are not responsible for any damage caused. \n Date and Time: \033[93m $(date) \033[0m         \n" 
    
}

function show_help {
    echo "Usage: Probezila [--install | --uninstall | -l <url> | -L <url_list_file> | -o <output_file> | -h]"
    echo "  --install             Install Probezila to /usr/local/bin/"
    echo "  --uninstall           Uninstall Probezila from /usr/local/bin/"
    echo "  -l <url>              Check a single URL"
    echo "  -L <url_list_file>    Check URLs from a list file"
    echo "  -o <output_file>      Write URLs with response 200 to the specified file"
    echo "  -h, --help            Show help"
    exit 1
}

function check_internet_connection() {
    if ! curl -s --head http://www.google.com/ &> /dev/null; then
        echo
        echo -e "\e[31m     No internet connection detected. Please check your internet connection.\e[0m"
        exit 1
    fi
}

function detect_cms() {
    url="$1"
    content=$(curl -sL "$url" | tr -d '\000')

    red_color=$(printf '\033[31m')
    light_blue_color=$(printf '\033[96m')
    blue_color=$(printf '\033[94m')
    pink_color=$(printf '\033[95m')
    yellow_color=$(printf '\033[93m')
    no_color=$(printf '\033[0m')

    if echo "$content" | grep -qi 'wp-content'; then
        echo -e "${yellow_color}[WordPress]${no_color}"
    elif echo "$content" | grep -qi 'Drupal.settings' || echo "$content" | grep -qi '/sites/all/'; then
        echo -e "${yellow_color}[Drupal]${no_color}"
    elif echo "$content" | grep -qi 'Joomla!'; then
        echo -e "${yellow_color}[Joomla]${no_color}"
    elif echo "$content" | grep -qi 'content="Squarespace"'; then
        echo -e "${yellow_color}[Squarespace]${no_color}"
    elif echo "$content" | grep -qi '/skin/frontend/' || echo "$content" | grep -qi 'Magento'; then
        echo -e "${yellow_color}[Magento]${no_color}"
    elif echo "$content" | grep -qi 'content="Wix.com Website Builder"'; then
        echo -e "${yellow_color}[Wix]${no_color}"
    elif echo "$content" | grep -qi 'var Shopify' || echo "$content" | grep -qi 'shopify.com'; then
        echo -e "${yellow_color}[Shopify]${no_color}"
    elif echo "$content" | grep -qi '<meta name="generator" content="Blogger"'; then
        echo -e "${yellow_color}[Blogger]${no_color}"
    elif echo "$content" | grep -qi 'ghost.org'; then
        echo -e "${yellow_color}[Ghost]${no_color}"
    elif echo "$content" | grep -qi 'This website is powered by TYPO3'; then
        echo -e "${yellow_color}[TYPO3]${no_color}"
    elif echo "$content" | grep -qi 'content="PrestaShop"'; then
        echo -e "${yellow_color}[PrestaShop]${no_color}"
    elif echo "$content" | grep -qi '/index.php?route='; then
        echo -e "${yellow_color}[OpenCart]${no_color}"
    elif echo "$content" | grep -qi '<link href="//cdn.bcapp/'; then
        echo -e "${yellow_color}[BigCommerce]${no_color}"
    elif echo "$content" | grep -qi '/includes/templates/'; then
        echo -e "${yellow_color}[Zen Cart]${no_color}"
    elif echo "$content" | grep -qi 'content="osCommerce"'; then
        echo -e "${yellow_color}[osCommerce]${no_color}"
    elif echo "$content" | grep -qi 'content="Weebly"'; then
        echo -e "${yellow_color}[Weebly]${no_color}"
    elif echo "$content" | grep -qi 'data-wf-page'; then
        echo -e "${yellow_color}[Webflow]${no_color}"
    elif echo "$content" | grep -qi '<!-- This is Squiz Matrix -->'; then
        echo -e "${yellow_color}[Squiz Matrix]${no_color}"
    elif echo "$content" | grep -qi 'X-HubSpot-Correlation-Id'; then
        echo -e "${yellow_color}[HubSpot]${no_color}"
    elif echo "$content" | grep -qi 'content="Moodle"'; then
        echo -e "${yellow_color}[Moodle]${no_color}"
    elif echo "$content" | grep -qi 'Powered by <a href="http://www.silverstripe.org">SilverStripe</a>'; then
        echo -e "${yellow_color}[SilverStripe]${no_color}"
    elif echo "$content" | grep -qi 'generator" content="DNN'; then
        echo -e "${yellow_color}[DNN]${no_color}"
    elif echo "$content" | grep -qi 'X-Drupal-Cache'; then
        echo -e "${yellow_color}[Drupal (Detected via Headers)]${no_color}"
    elif echo "$content" | grep -qi '<meta name="generator" content="vBulletin'; then
        echo -e "${yellow_color}[vBulletin]${no_color}"
    elif echo "$content" | grep -qi 'content="Concrete5'; then
        echo -e "${yellow_color}[Concrete5]${no_color}"
    elif echo "$content" | grep -qi '<link rel="stylesheet" href="/bitrix/templates'; then
        echo -e "${yellow_color}[Bitrix]${no_color}"
    elif echo "$content" | grep -qi 'Powered by <a href="https://www.plone.org">Plone</a>'; then
        echo -e "${yellow_color}[Plone]${no_color}"
    elif echo "$content" | grep -qi 'X-Powered-CMS: Bolt'; then
        echo -e "${yellow_color}[Bolt (Detected via Headers)]${no_color}"
    elif echo "$content" | grep -qi 'name="generator" content="Umbraco'; then
        echo -e "${yellow_color}[Umbraco]${no_color}"
    else
        echo -e "${red_color} ${no_color}"
    fi
}

function detect_waf() {
    url="$1"
    # Fetch the headers
    headers=$(curl -sI "$url")

    normalized_headers=$(echo "$headers" | awk '{print tolower($0)}')

    GREEN=$(printf '\033[92m')
    RED=$(printf '\033[91m')
    CYAN=$(printf '\033[36m')
    NC=$(printf '\033[0m') # No Color

    if echo "$normalized_headers" | grep -qi 'x-sucuri-id'; then
        echo -e "${RED}[Sucuri WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: cloudflare'; then
        echo -e "${RED}[Cloudflare WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: akamaighost'; then
        echo -e "${RED}[Akamai WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-powered-by: imperva'; then
        echo -e "${RED}[Imperva WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-cdn: incapsula'; then
        echo -e "${RED}[Incapsula WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-fw-server'; then
        echo -e "${RED}[Flywheel WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-edgeconnect-midmile-rtt'; then
        echo -e "${RED}[EdgeConnect WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-waf-event-id'; then
        echo -e "${RED}[F5 Big IP WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-amz-cf-id'; then
        echo -e "${RED}[AWS CloudFront WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'bwaf'; then
        echo -e "${RED}[Barracuda WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-forti-id'; then
        echo -e "${RED}[Fortinet FortiWeb WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-wallarm-instance-id'; then
        echo -e "${RED}[Wallarm WAF]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-shield-request-id'; then
        echo -e "${RED}[Reblaze WAF]${NC}"
     elif echo "$normalized_headers" | grep -qi 'x-content-type-options: nosniff' || \
         echo "$normalized_headers" | grep -qi 'x-xss-protection'; then
        echo -e "${CYAN}[WAF]${NC}"
    else
        echo -e "${NC}                ${NC}"
    fi
}

function detect_cdn() {
    url="$1"
    headers=$(curl -sI "$url")

    normalized_headers=$(echo "$headers" | awk '{print tolower($0)}')

    GREEN=$(printf '\033[92m')
    RED=$(printf '\033[91m')
    YELLOW=$(printf '\033[33m')
    NC=$(printf '\033[0m') # No Color

    if echo "$normalized_headers" | grep -qi 'cf-ray:'; then
        echo -e "${GREEN}[Cloudflare CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: cloudfront'; then
        echo -e "${GREEN}[Amazon CloudFront CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'akamai'; then
        echo -e "${GREEN}[Akamai CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-cache: hit from cloudfront'; then
        echo -e "${GREEN}[Amazon CloudFront CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: cdn77'; then
        echo -e "${GREEN}[CDN77]${NC}"
    elif echo "$normalized_headers" | grep -qi 'via: fastly'; then
        echo -e "${GREEN}[Fastly CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: keycdn'; then
        echo -e "${GREEN}[KeyCDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-cdn-geo'; then
        echo -e "${GREEN}[OVH CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-cdn: Incapsula'; then
        echo -e "${GREEN}[Incapsula CDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: bunny'; then
        echo -e "${GREEN}[BunnyCDN]${NC}"
    elif echo "$normalized_headers" | grep -qi 'x-edge-ip:'; then
        echo -e "${GREEN}[StackPath]${NC}"
    elif echo "$normalized_headers" | grep -qi 'server: limelight'; then
        echo -e "${GREEN}[Limelight Networks]${NC}"
    else
        echo -e "${RED}               ${NC}"
    fi
}

function install_probezila {
    # Check if script is already installed
    if [ -f "$INSTALL_PATH" ]; then
        echo -e "\e[33mProbezila is already installed at $INSTALL_PATH.\e[0m"
        exit 0
    fi

    sudo cp "$0" "$INSTALL_PATH"
    if [ $? -ne 0 ]; then
        echo -e "\e[31mInstallation failed. Please check your permissions.\e[0m"
        exit 1
    fi

    sudo chmod +x "$INSTALL_PATH"
    if [ $? -ne 0 ]; then
        echo -e "\e[31mFailed to make Probezila executable.\e[0m"
        exit 1
    fi

    echo -e "\e[92mProbezila has been installed successfully to $INSTALL_PATH.\e[0m"
    echo -e "You can now run it using the command: \e[93mProbezila\e[0m"
    exit 0
}

function uninstall_probezila {
    if [ ! -f "$INSTALL_PATH" ]; then
        echo -e "\e[33mProbezila is not installed on this system.\e[0m"
        exit 0
    fi

    sudo rm "$INSTALL_PATH"
    if [ $? -ne 0 ]; then
        echo -e "\e[31mUninstallation failed. Please check your permissions.\e[0m"
        exit 1
    fi

    echo -e "\e[92mProbezila has been uninstalled successfully from $INSTALL_PATH.\e[0m"
    exit 0
}

function handle_install_uninstall {
    case "$1" in
        --install)
            install_probezila
            ;;
        --uninstall)
            uninstall_probezila
            ;;
        *)
            show_help
            ;;
    esac
}

show_ascii_art
check_internet_connection
echo -e 

if [ "$#" -eq 0 ]; then
    show_help
fi

if [[ "$1" == "--install" || "$1" == "--uninstall" ]]; then
    handle_install_uninstall "$1"
fi

output_file=""
while getopts ":l:L:o:h" opt; do
    case $opt in
        l)
            single_url="$OPTARG"
            ;;
        L)
            url_list_file="$OPTARG"
            ;;
        o)
            output_file="$OPTARG"
            ;;
        h|?)
            show_help
            ;;
    esac
done

function check_url() {
    url="$1"
    outfile="$2"
    response_code=$(curl -sL -w "%{http_code}" "$url" -o /dev/null)
    cms=$(detect_cms "$url")
    waf=$(detect_waf "$url")
    cdn=$(detect_cdn "$url")
    reset_color=$(printf '\033[0m')
    url_color=$(printf '\033[97m')
    cms_color=$(printf '\033[93m')
    
    case $response_code in
        200)
            status_color=$(printf '\033[92m') 
            status_message="  [+] [Online]"
            if [ -n "$outfile" ]; then
                echo "$url" >> "$outfile"
            fi
            ;;
        301)
            status_color=$(printf '\033[33m') 
            status_message="  [+] [Moved Permanently]"
            ;;
        401)
            status_color=$(printf '\033[96m') 
            status_message="  [+] [Unauthorized]"
            ;;
        403)
            status_color=$(printf '\033[93m')
            status_message="  [!] [Forbidden]"
            ;;
        404)
            status_color=$(printf '\033[31m') 
            status_message="  [x] [Not Found]"
            ;;
        400)
            status_color=$(printf '\033[31m') 
            status_message="  [+] [Bad Request]"
            ;;
        *)
            status_color=$(printf '\033[35m') 
            status_message="  [*] [Unknown Response]"
            ;;
    esac
    full_message="${status_color}${status_message} ${url_color}${url}${reset_color}  ${cms_color}${cms}${reset_color} ${waf_color}${waf}${cdn}${reset_color}"
    printf_width=180
    printf "%-${printf_width}s %sResponse code: %s%s\n" "$full_message" "$status_color" "$response_code" "$reset_color"
   
}

export -f check_url
export -f detect_cms
export -f detect_waf
export -f detect_cdn

if [ -n "$single_url" ]; then
    check_url "$single_url" "$output_file"
elif [ -n "$url_list_file" ]; then
    if ! command -v parallel &> /dev/null; then
        echo -e "\e[31mGNU parallel is not installed. Please install it to use this feature.\e[0m"
        exit 1
    fi
    parallel -j 50 check_url {} "$output_file" < "$url_list_file"
else
    show_help
fi

exit 0
