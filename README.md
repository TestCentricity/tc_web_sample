# tc_web_sample

This is a Cucumber based sample test suite and framework utilizing the TestCentricity™ gem and a page-object model architecture
for desktop and responsive mobile web functional testing of the UAL Flight Booking web portal. This project includes examples of
externally sourcing test data from an Excel `.xls`, a `.yml` or a `.json` data file.

Detailed HTML documentation for this project can be accessed by opening `/tc_web_sample/doc/index.html` in a web browser (after
downloading or cloning from the Github [repository](https://github.com/TestCentricity/tc_web_sample.git)).


## Gem Dependencies:

cucumber  [![Gem Version](https://badge.fury.io/rb/cucumber.svg)](https://badge.fury.io/rb/cucumber)

capybara  [![Gem Version](https://badge.fury.io/rb/capybara.svg)](https://badge.fury.io/rb/capybara)

testcentricity_web  [![Gem Version](https://badge.fury.io/rb/testcentricity_web.svg)](https://badge.fury.io/rb/testcentricity_web)


## Supporting Documentation

[TestCentricity Framework for Web - testcentricity_web gem](https://rubygems.org/gems/testcentricity_web)

[TestCentricityWeb - documentation](http://www.rubydoc.info/gems/testcentricity_web/)



## Prerequisites to running tests:

In order for Cucumber to execute features or scenarios from the `tc_web_sample` test automation project, a minimum of 3 conditions
must be specified in the Cucumber command line at runtime. These conditions include `target_test_environment`, `target_browser`, and
`test_context`.

### `target_test_environment`:

Automated tests may be targeted at one of 2 test environments. Those test environments are:

| **Value** | **Description**        |
|-----------|------------------------|
| `qa`      | QA environment         |
| `prod`    | PRODUCTION environment |

**NOTE:**  Both environments point to the same UAL Booking portal at http://www.united.com/ual/


### `test_context`:

Automated tests may be targeted at one of 4 test contexts. Those test contexts are:

| **Value** | **Description**                                                                                                                                                       |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `bat`     | Run only features/scenarios with `@bat` tag to execute a Build Acceptance Test suite                                                                                  |
| `regress` | Run all features/scenarios with `@regression` tag to execute a comprehensive Regression test suite                                                                    |
| `dev`     | Run only features/scenarios with `@dev` tag. Used to run only those features/scenarios that are tagged with `@dev`, are actively under development or being debugged. |
| `wip`     | Run only features/scenarios with `@wip` tag  (work in progress)                                                                                                       |

### `target_browser`:

Automated tests may be targeted at one of 5 supported desktop web browsers, which must already be locally installed on your test
workstation. Supported desktop browsers are:

| **Value** | **Description** |
|-----------|-----------------|
| `chrome`  | OS X or Windows |
| `firefox` | OS X or Windows |
| `edge`    | OS X or Windows |
| `safari`  | OS X only       |
| `ie`      | Windows only    |

Automated tests may also be executed on desktop browsers (Chrome, Edge, or Firefox) hosted on Selenium Grid 4 or Dockerized Selenium
Grid 4 environments. See instructions below.

Automated tests may also be targeted to run on cloud hosted desktop or mobile web browsers using using the following service:
* [Browserstack](https://www.browserstack.com/list-of-browsers-and-platforms?product=automate)
* [Sauce Labs](https://saucelabs.com/open-source#automated-testing-platform)
* [TestingBot](https://testingbot.com/features)
* [LambdaTest](https://www.lambdatest.com/selenium-automation)

Refer to the [Remote cloud hosted desktop and mobile web browsers](https://www.rubydoc.info/gems/testcentricity_web/#remote-cloud-hosted-desktop-and-mobile-web-browsers) section
of the TestCentricity gem documentation.


## Instructions for running tests sequentially:

These instruction are for the sequential execution of features/scenarios. Tests will be executed within a single browser instance.

1. Launch RubyMine, select the File/Open... menu item, navigate to the `tc_web_sample` folder on your computer, and click the OK
button to open the `tc_web_sample` project.

2. Open the Terminal window by selecting the View/Tool Windows/Terminal menu item.

3. Select values from above for the `target_test_environment`, `target_browser`, and `test_context` command line parameters.

4. To run Cucumber, execute the following command in the Terminal:

        bundle exec cucumber -p target_test_environment -p target_browser -p test_context
  
    **NOTE:**
      * To have Cucumber generate HTML formatted test results, append `-p report` to the above command line arguments.
      * If you are running tests against mobile web browsers, you can override the default screen orientation of the mobile device
      by appending `-p landscape` or `-p portrait` to the above command line arguments.

    For example, to execute the entire regression suite against the QA environment on a locally hosted Chrome browser, with test
    results being logged to an HTML test results file, execute the following command in the Terminal:
    
        bundle exec cucumber -p qa -p chrome -p regress -p report

    To execute the regression suite against the QA environment on a locally hosted Firefox browser, with test results being logged
    to an HTML test results file, execute the following command in the Terminal:
    
        bundle exec cucumber -p qa -p firefox -p regress -p report
    
    To execute the Build Acceptance Test suite against the PROD environment on a Chrome browser hosted on Selenium Grid 4 or
    Dockerized Selenium Grid 4 environments, include `-p grid` in the command line, as in the following command:
    
        bundle exec cucumber -p prod -p bat -p chrome -p grid

    To execute the Build Acceptance Test suite against the PROD environment on a locally emulated iPad Pro 12.9" Mobile Safari web
    browser in Portrait orientation, execute the following command in the Terminal:
    
        bundle exec cucumber -p prod -p ipad_pro_12_9 -p portrait -p bat

    The following command specifies that Cucumber will run the Build Acceptance Test suite in the QA environment on an XCode
    Simulator against an iPad Pro (12.9-inch) (5th generation) with iOS version 15.4 in landscape orientation:

        bundle exec cucumber -p qa -p bat -p ipad_pro_12_15_sim -p landscape

    **NOTE:** Appium must be running prior to executing this command. You can ensure that Appium Server is running by including `-p run_appium`
    in your command line:

        bundle exec cucumber -p qa -p bat -p ipad_pro_12_15_sim -p landscape -p run_appium


6. As the Cucumber tests are executing, the Terminal will display the lines of each feature file and scenario as they run in real-time.

7. Upon completion of test execution, the Terminal will display the final test results.

8. If you specified in the command line that HTML formatted test results should be generated (`-p report`), you can view them by
opening the `reports` folder in the `tc_web_sample` project directory, and selecting the `test_results.html` file. Right-clicking
on the `test_results.html` file will display a popup menu. Select the **Open in Browser** menu item, and then select a web browser
from the popup sub menu that appears. The formatted test results will open in the web browser that you selected.


## Instructions for running tests concurrently (parallel test execution)

These instruction are for the concurrent execution of features/scenarios, which reduces total test execution time by executing
feature/scenarios in parallel across multiple browser instances.

1. Launch RubyMine, select the File/Open... menu item, navigate to the `tc_web_sample` folder on your computer, and click the OK
button to open the `tc_web_sample` project.

2. Open the Terminal window by selecting the View/Tool Windows/Terminal menu item.

3. Select values from above for the `target_test_environment`, `target_browser`, and `test_context` command line parameters.

4. To run Cucumber tests in a specific test context, execute the following command in the Terminal:

        bundle exec parallel_cucumber features/ -o "-p parallel -p target_test_environment -p target_browser -p test_context"

    **NOTE:** If you are running tests against mobile web browsers, you can specify the screen orientation of the mobile device
    by including `-p landscape` or `-p portrait` to the above command line argument. For example, to execute the entire regression
    suite against the QA environment on multiple locally emulated iPad Pro Mobile Safari web browsers in Portrait orientation,
    execute the following command in the Terminal:

        bundle exec parallel_cucumber features/ -o "-p parallel -p qa -p regress -p ipad_pro_12_9 -p portrait"

    To execute the regression suite against the QA environment on multiple locally hosted Firefox web browsers, execute the
    following command in the Terminal:

        bundle exec parallel_cucumber features/ -o "-p parallel -p qa -p regress -p firefox"

5. As your Cucumber tests are executing, the Terminal window will display the lines of each feature file and scenario as they
run in real-time.

6. Upon completion of test execution, multiple HTML formatted test results can be reviewed by opening the `reports` folder in
the `tc_web_sample` project, and selecting and opening each of the `test_results.html` files individually.


## Detailed Documentation

Detailed HTML documentation of the features, scenarios, step definitions, classes, and methods for the `tc_web_sample` project can
be accessed from the `index.html` file within the `doc` folder in the `tc_web_sample` project folder:

    tc_web_sample
        ├── config
        ├── doc
        │   └── index.html
        ├── features
        └── reports

To view this documentation, navigate to the `index.html` file, right click on it, and select *Open in Browser*