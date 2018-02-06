# Application Performance Monitoring

The DevOps team has noticed that the Dealers page is slow to load and shows performance spikes with database calls in the Application Insights telemetry. By viewing the details of performance monitoring through Application Insights, we will be able to drill down to the code that has affected the slow performance of the web application and fix the code.

In this lab, you will learn how to set up Application Insights telemetry, and drill down into performance monitoring data through Application Insights in the new Azure Portal.

### Video ###

You may watch a [demo in Channel 9](https://channel9.msdn.com/Series/Parts-Unlimited-MRP-Labs/Parts-Unlimited-MRP-Application-Performance-Monitoring) that walks through many of the steps in the document.

**Prerequisites**

- Code Editor (VSCode, Eclipse, etc.)

- Continuous Integration build with Gradle to the PartsUnlimitedMRP virtual machine (see [link](https://github.com/Microsoft/PartsUnlimitedMRP/tree/master/docs/HOL_Continuous-Integration))

- Continuous Deployment with hosted agent (see [link](https://github.com/Microsoft/PartsUnlimitedMRP/tree/master/docs/HOL_Continuous-Deployment))

**Tasks Overview**

1. Set up Application Insights resources for PartsUnlimitedMRP

2. Configure Application Insights to record from your PartsUnlimitedMRP

3. Resolve performance issues that have been found

4. Introduction into live metrics 

### Task 1: Create the Application Insights Resource on Azure
**Step 1.** In an Internet browser, navigate to <http://portal.azure.com> and
sign in with your credentials.

![](<media/creation-step1.png>)

**Step 2.** Click on the "+ New" tile on the left column, select the "Monitoring + Management" option in
the azure marketplace and then "Application Insights". 

Alternatively after clicking on the "+ New" in the left column, search for
“Application Insights,” and click on the first result "Application Insights"

![](<media/creation-step2.png>)

**Step 3.** Fill the information asked, choose "Java web application" as the Application Type. We recommend deploying this resource in the same Resource Group that you have chosen for the virtual machine in the previous HOL. When completed, select the "Create" button.

![](<media/creation-step3.png>)

### Task 2: Configure your new Application Insights for PartsUnlimitedMRP
**Step 1.** Starting from the Azure Portal : <http://portal.azure.com> 

**Step 2.** Open your Application Insights telemetry service previously created for PartsUnlimitedMRP. This
can be done by selecting "All resources" on the left hand navigation and then clicking what you have named your Application Insights. 
Or, if you have the "All resources" clipped to your dashboard, then you can click directly into it from there. 

![](<media/app-insights-step1.png>)

![](<media/app-insights-step2.png>)

With the "Application Insights" now open, scroll down in Options and click on the Properties tile to find the Instrumentation key. 

![](<media/app-insights-step3.png>)

**Step 3.** Copy the Instrumentation Key in the Properties panel. You will need this when inserting the key into the ApplicationInsights.xml file in PartsUnlimitedMRP's resources folder. 

![](<media/app-insights-step4.png>)

**Step 4.** Navigate to the working folders of the PartsUnlimitedMRP repo in a code editor (such as VSCode). 

![](<media/app-insights-step5.png>)

**Step 5.** In `PartsUnlimitedMRP/src/Backend/OrderService/build.gradle`, confirm that the build file is importing `com.microsoft.appinsights.*` and is also compiling `com.microsoft.azure:applicationinsights-core:1.n`.

![](<media/app-insights-step6.png>)

**Step 6.** In `PartsUnlimitedMRP/src/OrderService/src/main/resources/ApplicationInsights.xml`, paste in the instrumentation key that you copied previously from the Azure Portal in between the `<InstrumentationKey>` tags. 

![](<media/app-insights-step7.png>)

**Step 7.** Additionally, verify that the following telemetry modules and telemetry initializers exist in between the `<TelemetryModules>` and `<TelemetryIntializers>` tags. 

Telemetry Modules:  

	<Add type="com.microsoft.applicationinsights.web.extensibility.modules.WebRequestTrackingTelemetryModule"/>
    <Add type="com.microsoft.applicationinsights.web.extensibility.modules.WebSessionTrackingTelemetryModule"/>
    <Add type="com.microsoft.applicationinsights.web.extensibility.modules.WebUserTrackingTelemetryModule"/>		

Telemetry Initializers:

	<Add type="com.microsoft.applicationinsights.web.extensibility.initializers.WebOperationIdTelemetryInitializer"/>
    <Add type="com.microsoft.applicationinsights.web.extensibility.initializers.WebOperationNameTelemetryInitializer"/>
    <Add type="com.microsoft.applicationinsights.web.extensibility.initializers.WebSessionTelemetryInitializer"/>
    <Add type="com.microsoft.applicationinsights.web.extensibility.initializers.WebUserTelemetryInitializer"/>
    <Add type="com.microsoft.applicationinsights.web.extensibility.initializers.WebUserAgentTelemetryInitializer"/>

![](<media/app-insights-step8.png>)

**Step 8.** Return to the Azure Portal. Under the Application Insights telemetry for PartsUnlimitedMRP, click on the tile in the overview timeline for application health, "Learn how to collect browser page load data." Once you click on it, a new panel should open that shows the end-user usage analytics code. Copy lines the script code outlined in green (including the `<script>` tags). 

![](<media/app-insights-step11.png>)

**Step 9.** Back in the code editor, insert the script code previously copied before the end of the `<HEAD>` tag for each of the HTML pages in PartsUnlimitedMRP, starting with the index page. In `PartsUnlimitedMRP/src/Clients/Web/index.html`, paste the script code before the other scripts inside of the `<HEAD>` tag. 

![](<media/app-insights-step12.png>)

**Step 10.** Repeat step 10 for the following HTML files:

- `PartsUnlimitedMRP/src/Clients/Web/pages/catalog/catalog.html`
- `PartsUnlimitedMRP/src/Clients/Web/pages/dealers/dealers.html`
- `PartsUnlimitedMRP/src/Clients/Web/pages/deliveries/deliveries.html`
- `PartsUnlimitedMRP/src/Clients/Web/pages/orders/orders.html`
- `PartsUnlimitedMRP/src/Clients/Web/pages/quotes/quotes.html`

**Step 11.** Commit and push the changes to kick off the Continuous Integration build with Gradle. 

![](<media/app-insights-step13.png>)

![](<media/app-insights-step14.png>)

**Step 12.** Return to the Azure Portal into the PartsUnlimitedMRP Application Insights telemetry to find data available for browser page loading and dependency durations. It may take a few moments for Application Insights to reload.

![](<media/app-insights-step14.png>)

### Task 3: Using Application Performance Monitoring to resolve performance issues

**Step 1.** In an Internet browser, navigate to the PartsUnlimitedMRP website (e.g. http://mylinuxvm.westus.cloudapp.azure.com:9080/mrp). This is the VM you previously deployed to. Navigate to the Dealers page. You'll notice immediately that the page takes a while for the dealers view to load. 

![](<media/performance-step1.png>)

**Step 2.** Re-navigate to your Application Insights resource by selecting "All resources" on the left hand navigation and then clicking what you have named your Application Insights. 
Or, if you have the "All resources" clipped to your dashboard then you can click directly into it from there. 

![](<media/performance-step2.png>)

**Step 3.** After selecting the Application Insights telemetry for your web app,
scroll down and select the “Performance” tile to view performance monitoring
information.

**Step 4.** In the performance tile of the Application Insights telemetry, note
the timeline. The timeline data may not show up immediately, so you may want to wait for a few minutes for the telemetry to collect performance data. 

![](<media/performance-step3.png>)

**Step 5.** Once data shows in the timeline, you will be able to view great information in the **Do my slowest operations correlate?** section. Under the heading **What are my slowest operations?** you can see that the dealers page took the longest to load. By clicking on the /dealer you are able to view further information on what has happened.

![](<media/performance-step4.png>)

**Step 6.** Drill down into the method that is affecting the slow performance. We now know that the slow performance is being caused by the DealersController in our code and that this is causing inefficient database calls. 

**Step 7.** Navigate to the working folders of the PartsUnlimitedMRP repo in a code editor (such as VSCode). 

![](<media/performance-step5.png>)

**Step 8.** Find the `getDealers()` method in `PartsUnlimitedMRP/src/Backend/OrderService/src/main/java/smpl/ordering/controllers/DealerController.java` that is causing slow performance.

![](<media/performance-step6.png>)

**Step 9.** In the `getDealers()` method, notice that there is a database call 100000 times with the variable, `numMongoDBCalls`. Change the value of this variable to be 1 so that there is only one call to the database to populate the dealers list. 

![](<media/performance-step7.png>)

**Step 10.** Save the changes and commit the changes on the master branch. Push the changes to the remote repo in VSO to kick off a Continuous Integration build. 

![](<media/performance-step8.png>)

**Step 11.** After the changes have been deployed to the website (This will take a few moments), open up a new incognito browser window (to prevent caching) and return to the Dealers page. The dealers will show up faster than they did previously now having only one call to the database. 

![](<media/performance-step9.png>)

**Step 12.** Return to the Application Insights performance monitoring view in the Azure Preview Portal and refresh the page. The **Do my slowest operations correlate?** will show the new requests with a better response times. 

### Task 4: Introduction into Live metrics

**Step 1.** Return to the Application Insights overview page you will see by default you will already have 1 server linked to the Live stream. By clicking this you will be taken through to the Live Metrics Stream. 

![](<media/live-step1.png>)

**Step 2.** The best part of this is it is setup for you already. In this view you are able to see all of the servers that are providing information for the metrics. 

This gives you access to be able to see live what is happening to in PartsUnlimitedMRP and the servers you have running. Showing issues that could be occurring on your live site, including the overall health of the serves. 

![](<media/live-step2.png>)

In this lab, you learned how to set up Application Insights telemetry, and drill down into performance
monitoring data through Application Insights in the new Azure Portal.

**Further Resources**

[Get started with Application Insights in a Java web project](https://azure.microsoft.com/en-us/documentation/articles/app-insights-java-get-started/)

[Unix performance metrics in Application Insights](https://azure.microsoft.com/en-us/documentation/articles/app-insights-java-collectd/)

[Application Insights API for custom events and metrics](https://azure.microsoft.com/en-us/documentation/articles/app-insights-web-track-usage-custom-events-metrics/)

# Continuous Feedbacks

#### Issues / Questions about this HOL ??

[If you are encountering some issues or questions during this Hands on Labs, please open an issue by clicking here](https://github.com/Microsoft/PartsUnlimitedMRP/issues)

Thank you