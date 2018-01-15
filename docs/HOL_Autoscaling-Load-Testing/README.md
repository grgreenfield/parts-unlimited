# Please visit [http://aka.ms/pumrplabs](http://aka.ms/pumrplabs)

We are now updating only the documentation here : [http://aka.ms/pumrplabs](http://aka.ms/pumrplabs)
====================================================================================

# HOL - Auto-Scaling and Load Testing

Your Linux Azure virtual machine has suffered significant performance degradation during Black Friday. The business unit responsible for the website’s functionality has complained to IT staff that users would intermittently lose access to the website, and that load times were significant for those who could access it.

In this lab, you will learn how to perform load testing against an endpoint for the PartsUnlimitedMRP Linux Azure virtual machine. Additionally, you will create a virtual machine and VM Scale Set using Azure Command Line tools, as well as add both to a shared availability set to configure auto-scaling the set in cloud services. 

**Pre-requisites**

- The PartsUnlimitedMRP Linux Azure virtual machine set up and deployed with endpoint 9080 open (see [link](https://github.com/Microsoft/PartsUnlimitedMRP/blob/master/docs/Build-MRP-App-Linux.md)) this would be setup through Continuous Deployment (viewable [here](https://github.com/Microsoft/PartsUnlimitedMRP/tree/master/docs/HOL_Continuous-Deployment))

- Visual Studio Ultimate license

- Azure CLI 2.0 (see [link](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli?view=azure-cli-latest))

**Tasks**

1. Setting up and running a load test in Visual Studio Team Services
2. Creating virtual machines with Azure 2.0 CLI
3. Configuring with availability groups in Azure Management Portal
4. Running a load test to verify auto-scaling

###Task 1: Setting up and running a load test in Visual Studio Team Services

Performing a load test can be done in Visual Studio, in a browser in Visual Studio Team Services, or in the new Azure Portal. For simplicity, we will run a load test in a browser in Visual Studio Team Services. 

**1.** Open a web browser and navigate to the Team Project Collection ("DefaultCollection") of your Visual Studio Team Services account, such as:

    https://{VSTS instance}.visualstudio.com

On the upper-left set of tabs, click on "Test" and then on "Load Test" to open up load test options in the browser. 

![](<media/shot1.png>)

**2.** In the load test tab, create a simple load test in the browser. Click on the **New** button and select **URL-based test** to create a new URL-based test.

![](<media/shot2.png>)

**3.** Name the load test *PartsUnlimitedMRP Homepage Load Test*. Specify the home page URL, which should be the URL to MRP with your virtual machine name and port (such as *http://{mycloudhostname}.cloudapp.net:9080/mrp*).

![](<media/shot3.png>)

**4.** Select the **Settings** tab and change the **Run duration** to 1 minute. You can optionally change the max virtual users, browser mix, and load location as well. Then click the **Save** button.

![](<media/shot4.png>)

**Step 4.** Click on the **Run test** button to begin the test. The load test will start running and show metrics in real time. 

![](<media/run_test.png>)

**Step 5.** When the test has finished loading, it will show metrics, errors, and application performance. We should be able to solve this issue by creating an availability set for the virtual machines and configuring auto-scaling.

![](<media/shot5.png>)

###Task 2: Creating virtual machines with Azure CLI
Creating a VM image from you already set up mrp linux machine and creating a Virtual Machine Scale Set with it, from the Azure 2.0 CLI.

**1.** Ensure that the PartsUnlimitedMRP machine is running. SSH into the machine with your credentials. 

    ssh <login>@<dnsname>.cloudapp.net

![](<media/ssh_virtual_machine.png>)

**2.** In the SSH window, type the following command:

    sudo waagent -deprovision+user

Type y to continue where required.

**3.** De-allocate the VM that you have de-provisioned by:

    az vm deallocate --resource-group "parts" --name "partsdnsmrp"

Where --resource-group is the name of your group and --name is the name of the VM.

**4.** Make sure that the VM is marked as generalized with:

    az vm generalize --resource-group "parts" --name "partsdnsmrp"

**5.** Now to create the image by:

    az image create --resource-group "parts" --name "partsimage" --source "partsdnsmrp"

Where now the --name is the name you wish the image to be called and the --source being the VM.

**6.** Once the virtual machine image has been created, we need to create the scale set using the image you have created.

    az vmss create --resource-group parts --name partsScaleSet --image partsimage --upgrade-policy-mode automatic --admin-username azureuser --admin-password Pa55word.012345

You need to make sure that the scale set is in the same resource group as the image. The password needs to be at least 12 characters long.

**7.** After the VM Scale Set has been created you are able to view them in the Azure Portal. To Enable autoscale on the Scale Set you need to select Scaling under Settings and select the Enable Autoscale button.

![](<media/shot3s.png>)

**8.** You will need to name the new autoscale that you are about to make, then add a rule. 

![](<media/shot4s.png>)

I have used the default that is provided as listed above, then select add and finish up with a save.

You have now created a scale set that we auto scale based off of the influx of use.

###Task 3: Running a load test to verify auto-scaling

We now have Virtual Machine Scale Set that scales by CPU so that whenever the CPU percentage for PartsUnlimitedMRP is over the threshold of 80%, Azure will automatically add an instance to the virtual machine. We can now run a load test again to compare the results. 

**1.** Navigate to the Team Project Collection ("DefaultCollection") of your Visual Studio Team Services account, such as:

    https://{VSTS instance}.visualstudio.com

On the upper-left set of tabs, click on "Load test" to open up load test options in the browser. 

![](<media/shot1.png>)

**2.** You will need to update the DNS of the load tests to reflect the DNS of the scale set.

![](<media/shot5s.png>)

**3.** Select to save the change and Run test. The load test will start running and show metrics in real time. 

![](<media/shot6s.png>)

The average response time has improved by autoscaling multiple virtual machines in Azure based on CPU load. 

In this lab, you learned how to perform load testing against an endpoint for the PartsUnlimitedMRP Linux Azure virtual machine. Additionally, you created a virtual machine image and VM Scale Set using Azure Command Line tools, as well as add both to a shared availability set to configure auto-scaling the set in cloud services.

Next steps
----------

-   [HOL Parts Unlimited MRP Continuous Integration ](https://github.com/Microsoft/PartsUnlimitedMRP/tree/master/docs/HOL_Continuous-Integration)

-   [HOL Parts Unlimited MRP Automated Testing](https://github.com/Microsoft/PartsUnlimitedMRP/tree/master/docs/HOL_Automated-Testing)

-   [HOL Parts Unlimited MRP Application Performance Monitoring](https://github.com/Microsoft/PartsUnlimitedMRP/tree/master/docs/HOL_Application-Performance-Monitoring)