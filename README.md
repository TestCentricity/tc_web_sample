# tc_web_sample

This is a Cucumber based sample test suite and framework utilizing the TestCentricity™ gem and a page-object model architecture for desktop and responsive mobile web functional
testing of the UAL Flight Booking web portal. This project includes examples of externally sourcing test data from an Excel file and support for testing multiple language/locale
combinations.


## Gem Dependencies:

cucumber  [![Gem Version](https://badge.fury.io/rb/cucumber.svg)](https://badge.fury.io/rb/cucumber)

capybara  [![Gem Version](https://badge.fury.io/rb/capybara.svg)](https://badge.fury.io/rb/capybara)

testcentricity_web  [![Gem Version](https://badge.fury.io/rb/testcentricity_web.svg)](https://badge.fury.io/rb/testcentricity_web)


## Supporting Documentation

[TestCentricity Framework for Web - testcentricity_web gem](https://rubygems.org/gems/testcentricity_web)

[TestCentricityWeb - documentation](http://www.rubydoc.info/gems/testcentricity_web)



## Prerequisites to running tests:

In order for Cucumber to execute features or scenarios from the tc_web_sample test automation project, a minimum of 3 conditions must be specified in the
Cucumber command line at runtime. These conditions include `target_test_environment`, `target_browser`, and `test_context`.

### `target_test_environment`:

Automated tests may be targeted at one of 2 test environments. Those test environments are:

**Value** | **Description**
----------|----------------
`test`    | TEST environment
`prod`    | PRODUCTION environment

**NOTE:**  Both environments point to the same UAL Booking portal at http://www.united.com/ual/


### `test_context`:

Automated tests may be targeted at one of 4 test contexts. Those test contexts are:

**Value** | **Description**
----------|----------------
`bat`     | Run only features/scenarios with `@bat` tag to execute a Build Acceptance Test suite
`regress` | Run only features/scenarios with `@regression` tag to execute a comprehensive Regression test suite
`dev`     | Run only features/scenarios with `@dev` tag. Used to run only those features/scenarios that are tagged with `@dev`, are actively under development or being debugged.
`wip`     | Run only features/scenarios with `@wip` tag  (work in progress)


### `target_browser`:

Automated tests may be targeted at one of 7 supported desktop web browsers, which must already be locally installed on your test workstation. Supported desktop browsers are:

**Value**          | **Description**
-------------------|----------------
`chrome`           | OS X or Windows
`chrome_headless`  | OS X or Windows (headless - no visible UI)
`firefox`          | OS X or Windows (Firefox version 55 or greater only)
`firefox_headless` | OS X or Windows (headless - no visible UI)
`firefox_legacy`   | OS X or Windows (Firefox version 47.0.1 only)
`safari`           | OS X only
`ie`               | Windows only (IE version 10.x or greater only)

Automated tests may also be targeted at one of 44 supported emulated mobile web browsers, hosted within a local instance of the Chrome desktop browser. The specified mobile
browser's user agent, CSS screen dimensions, and default screen orientation will be automatically set in the local Chrome browser instance. Supported mobile browsers are:

**Value**             | **CSS Screen Dimensions** | **Default Orientation**  | **OS Version**
----------------------|---------------------------|--------------------------|---------------
`ipad`                |1024 x 768 |landscape |iOS 10
`ipad_pro`            |1366 x 1024|landscape |iOS 11
`ipad_pro_10_5`       |1112 x 834 |landscape |iOS 11
`ipad_chrome`         |1024 x 768 |landscape |iOS 10 - Mobile Chrome browser for iOS
`ipad_firefox`        |1024 x 768 |landscape |iOS 10 - Mobile Firefox browser for iOS
`ipad_edge`           |1024 x 768 |landscape |iOS 10 - Mobile Edge browser for iOS
`android_tablet`      |1024 x 768 |landscape |Android 3.0
`kindle_fire`         |1024 x 600 |landscape |
`kindle_firehd7`      |800 x 480  |landscape |Fire OS 3
`kindle_firehd8`      |1280 x 800 |landscape |Fire OS 5
`kindle_firehd10`     |1920 x 1200 |landscape |Fire OS 5
`surface`             |1366 x 768 |landscape |
`blackberry_playbook` |1024 x 600 |landscape |BlackBerry Tablet OS
`samsung_galaxy_tab`  |1280 x 800 |landscape |Android 4.0.4
`google_nexus7`       |960 x 600  |landscape |Android 4.4.4
`google_nexus9`       |1024 x 768 |landscape |Android 5.1
`google_nexus10`      |1280 x 800 |landscape |Android 5.1
`iphone`              |320 x 480  |portrait  |iOS 9.1
`iphone4`             |320 x 480  |portrait  |iOS 9.1
`iphone5`             |320 x 568  |portrait  |iOS 9.1
`iphone6`             |375 x 667  |portrait  |iOS 9.1
`iphone6_plus`        |414 x 736  |portrait  |iOS 9.1
`iphone7`             |375 x 667  |portrait  |iOS 10
`iphone7_plus`        |414 x 736  |portrait  |iOS 10
`iphone7_chrome`      |375 x 667  |portrait  |iOS 11 - Mobile Chrome browser for iOS
`iphone7_firefox`     |375 x 667  |portrait  |iOS 11 - Mobile Firefox browser for iOS
`iphone7_edge`        |375 x 667  |portrait  |iOS 11 - Microsoft Edge browser for iOS
`iphone8`             |375 x 667  |portrait  |iOS 11
`iphone8_plus`        |414 x 736  |portrait  |iOS 11
`iphonex`             |375 x 812  |portrait  |iOS 11
`android_phone`       |360 x 640  |portrait  |Android 4.2.1
`nexus6`              |411 x 731  |portrait  |Android 6
`pixel`               |411 x 731  |portrait  |Android 8
`pixel_xl`            |411 x 731  |portrait  |Android 8
`samsung_galaxy_s4`   |360 x 640  |portrait  |Android 5.0.1
`samsung_galaxy_s5`   |360 x 640  |portrait  |Android 6.0.1
`samsung_galaxy_s6`   |360 x 640  |portrait  |Android 6.0.1
`windows_phone7`      |320 x 480  |portrait  |Windows Phone OS 7.5
`windows_phone8`      |320 x 480  |portrait  |Windows Phone OS 8.0
`lumia_950_xl`        |360 x 640  |portrait  |Windows Phone OS 10
`blackberry_z10`      |384 x 640  |portrait  |BlackBerry 10 OS
`blackberry_z30`      |360 x 640  |portrait  |BlackBerry 10 OS
`blackberry_leap`     |360 x 640  |portrait  |BlackBerry 10 OS
`blackberry_passport` |504 x 504  |square    |BlackBerry 10 OS

To change the emulated device's screen orientation from the default setting, set the `ORIENTATION` Environment Variable to either `portrait` or `landscape`.

Automated tests may also be targeted to run on cloud hosted desktop or mobile web browsers using the BrowserStack, Sauce Labs, CrossBrowserTesting, or TestingBot
services. For instructions on using these cloud hosted services, refer to the [Remotely hosted desktop and mobile web browsers](http://www.rubydoc.info/gems/testcentricity_web/2.4.2#Remotely_hosted_desktop_and_mobile_web_browsers) section
of the TestCentricityWeb gem documentation. 


## Instructions for running the test suite:

1.  Launch RubyMine, select the File/Open... menu item, navigate to the `tc_web_sample` folder on your drive's Home directory or your C: drive, and click the OK
button to open the `tc_web_sample` project.

2.  Open the Terminal window by selecting the View/Tool Windows/Terminal menu item.

3.  Select values from above for the `target_test_environment`, `target_browser`, and `test_context` command line parameters.

4.  To run Cucumber, execute the following command in the RubyMine Terminal window:
  `bundle exec cucumber -p target_test_environment -p target_browser -p test_context`
  
**NOTE:**  To have Cucumber generate HTML formatted test results, append `-p report` to the above command line arguments.

**NOTE:**  If you are running tests against mobile web browsers, you can override the default screen orientation of the mobile device by appending `-p landscape` or `-p portrait`
to the above command line arguments.

For example, to execute the entire regression suite against the TEST environment on a locally hosted Chrome browser, with test results being logged to an HTML test results
file, execute the following command in the Terminal:
    `bundle exec cucumber -p test -p chrome -p regress -p report`
    
To execute the Build Acceptance Test suite against the PROD environment on a locally emulated iPad Pro Mobile Safari web browser in Portrait orientation, execute the following
command in the Terminal:
    `bundle exec cucumber -p prod -p ipad_pro -p portrait -p bat`

5.  As the Cucumber tests are executing, the Terminal window will display the lines of each feature file and scenario as they run in real-time.

6.  Upon completion of test execution, the Terminal window will display the final results.

7.  If you specified in the command line that HTML formatted test results should be generated, you can examine them by opening the reports folder in the `tc_web_sample` project
directory, and selecting the `test_results.html` file.

Right-clicking on the `test_results.html` file will display a popup menu. Select the Open in Browser menu item, and then select a browser from the popup sub menu that appears.
The HTML formatted test results will open in the web browser that you selected.


## Multiple Language/Locale Testing

This sample test framework includes support for test execution against 7 language/locale combinations. The supported `target_locale` options are:

**Value** | **Language** | **Country**
----------|--------------|------------
`en-us`   | English      | United States *(default)*
`en-us`   | English      | Canada
`es-mx`   | Spanish      | Mexico
`es-es`   | Spanish      | Spain
`de-de`   | German       | Germany
`fr-ca`   | French       | Canada
`fr-fr`   | French       | France

To specify one of the 7 supported language/locale combinations at runtime, include `-p target_locale` as one of the command line arguments. For instance, to to execute the
Build Acceptance Test suite against the TEST environment on a locally hosted Chrome browser as a French Canadian user, execute the following command in the Terminal:

    `bundle exec cucumber -p test -p chrome -p bat -p fr-ca`

**NOTE:**  If you do not specify a target locale, the default target locale will be `en-us` (U.S./English).
