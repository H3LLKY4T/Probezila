# Probezila
Probezila is a versatile, multi-OS command-line tool designed for BugBounty Hunters, security researchers, and IT professionals across various platforms, including macOS, Arch Linux, and Debian Linux. It enables the user to efficiently check the availability of websites, detect the Content Management System (CMS) they are using, identify any Web Application Firewall (WAF) protections in place, and determine the Content Delivery Network (CDN) services utilized. This tool is ideal for performing bulk URL analyses, aiding in cybersecurity assessments, and web technology research.
## Features
* **Availability Check:** Verifies if a website is online and responsive.
* **CMS Detection:** Identifies the CMS used by a website, supporting popular platforms like WordPress, Drupal, Joomla, and more.
* **WAF Detection:** Detects the presence of Web Application Firewalls by analyzing HTTP response headers.
* **CDN Detection:** Identifies if the website is using CDN services for content delivery.
* **Bulk Analysis:** Allows the processing of multiple URLs through a list file, enhancing productivity for large-scale analyses.
* **Output Customization:** Users can specify an output file to capture URLs that return a 200 OK response, facilitating the documentation of live websites.

## Requirements
### GNU Parallel Installation:
#### **macOS:**
GNU Parallel can be installed on macOS using Homebrew. If you haven't installed Homebrew yet, you can do so by executing the following command in the terminal:
 ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 ```
Once Homebrew is installed, you can install GNU Parallel by running:
 ```
brew install parallel
 ```
#### **Arch Linux:**
On Arch Linux, GNU Parallel is available in the community repository. You can install it using pacman:
 ```
sudo pacman -S parallel
 ```
#### **Debian Linux:**
For Debian-based distributions, GNU Parallel can be installed from the default repositories:
 ```
sudo apt-get update
sudo apt-get install parallel
 ```
## Installation
Git clone the script from github:
 ```
git clone https://github.com/H3LLKY4T/Probezila.git
 ```
Ensure the script is executable by navigating to the Probezila directory and running:
 ```
cd Probezila
chmod +x install.sh
 ```
## Usage
#### **Checking a Single URL**
When you use the -l flag followed by a URL, Probezila scans that specific URL. This option is useful for quick checks on individual websites.
 ```
Probezila -l www.example.com
 ```
#### **Checking Multiple URLs from a List**
If you have a list of URLs that you want to scan, you can use the -L flag followed by the filename where your URLs are listed (one URL per line). This batch processing mode is efficient for analyzing multiple websites in one go.
 ```
Probezila -L urllist.txt
 ```
#### **Saving Online URLs to a File**
When you want to save the results of your scan, specifically the URLs that are online (returning a 200 OK response), you can use the -o flag followed by the filename where you wish to save these URLs. This feature is particularly useful for filtering out active websites from a large list, allowing for focused analysis or follow-up actions on responsive URLs only.
 ```
Probezila -L urllist.txt -o aliveurls.txt
 ```
