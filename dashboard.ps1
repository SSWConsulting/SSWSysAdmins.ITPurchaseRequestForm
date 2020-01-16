<#
.SYNOPSIS
    IT Purchase Request form for easier requesting the purchase of IT goods.
.DESCRIPTION
    Universal Dashboard-powered form of IT Purchase Request, where you can input the products meant to be bought and it will send the correct email and layout. 
.EXAMPLE
    PS C:\> Dashboard.ps1 to run the dashboard
    After running, it will be available at port 10000 in your own machine (dictated by the Start-UDDashboard command at the end)
.INPUTS
    None.
.OUTPUTS
    None.
#>

$Theme = New-UDTheme -Name "Basic" -Definition @{
    '.card-content' = @{
        'display' = 'grid'
    }
    '.btn'          = @{
        'background-color' = 'rgb(204,65,65)'
    }
    UDNavBar        = @{
        BackgroundColor = "rgb(204,65,65)"
        FontColor       = "rgb(51,51,51)"
    }
    UDFooter        = @{
        BackgroundColor = "rgb(204,65,65)"
        FontColor       = "rgb(51,51,51)"
    }
    UDCard          = @{
        BackgroundColor = "rgb(204,65,65)"
        FontColor       = "rgb(51,51,51)"
    }
    UDChart         = @{
        BackgroundColor = "rgb(204,65,65)"
        FontColor       = "rgb(51,51,51)"
    }
    UDCounter       = @{
        #BackgroundColor = "rgb(204,65,65)"
        FontColor = "rgb(51,51,51)"
    }
    UDMonitor       = @{
        #BackgroundColor = "rgb(204,65,65)"
        #FontColor = "rgb(51,51,51)"
    }
    UDGrid          = @{
        #BackgroundColor = "rgb(204,65,65)"
        #FontColor = "rgb(51,51,51)"
    }
    UDInput         = @{
        #BackgroundColor = "rgb(204,65,65)"
        FontColor = "rgb(51,51,51)"
    }
    UDTable         = @{
        #BackgroundColor = "rgb(204,65,65)"
        #FontColor = "rgb(51,51,51)"
    }
    UDButton        = @{
        BackgroundColor = "rgb(204,65,65)"
        FontColor       = "rgb(51,51,51)"
    }
}

$Page1 = New-UDPage -Name "Home" -Icon Home -Content {
    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDHeading -Size 2 -Content { "Welcome to the IT Purchase Request Form!" }
            New-UDHTML -Markup "<h6>This as per <a href=https://my.sugarlearning.com/SSW/items/13215/purchase-please-getting-approval-for-purchases-3-it-purchases>https://my.sugarlearning.com/SSW/items/13215/purchase-please-getting-approval-for-purchases-3-it-purchases</a><h6>"
            New-UDHTML -Markup "<h5>What is this page for?<h5>"
            New-UDHTML -Markup "<h6>This is a form created to make it easy to build and send an email to the right place when making an IT Purchase Request. You still have to search for the best price and correct product!<h6>"
            New-UDHTML -Markup "<h5>How does it work?<h5>"
            New-UDHTML -Markup "<h6><ol><li>Check the checkboxes below | Go to next page</li><li>Add your products | Hit Continue when done</li><li>Review the products you entered | Input the Grand Total of the purchase | Send the final email</li><li>SysAdmins will approve or not the purchase.</li><h6>"
        }
        New-UDColumn -Size 4 {
            New-UDCheckbox -id "CostBenefit" -Label "Have you searched for the best price?" -OnChange {
                Set-UDElement -id "ContinueButton" -Content {
                    New-UDButton -Text "Continue to Next Page" -OnClick {
                        Invoke-UDRedirect -Url "/Products"
                    }
                }
            }
        }
        New-UDColumn -Size 4 {
            New-UDElement -Tag "div" -Id "ContinueButton"
        }
    }
}

$Page2 = New-UDPage -Url "/Products/" -Endpoint {
    param()

    # Creates an array to hold the objects
    $Session:FinalArray = @()
        
    # Creates the session variable to hold the Purchase Description
    $Session:FinalDescription = ""

    function Set-InputNumber {
        param (
            $InputNumber
        )

        if ($InputNumber -eq 1) {
            return $Session:Inputs1
        }
        elseif ($InputNumber -eq 2) {
            return $Session:Inputs2
        }
        elseif ($InputNumber -eq 3) {
            return $Session:Inputs3
        }
        elseif ($InputNumber -eq 4) {
            return $Session:Inputs4
        }
        elseif ($InputNumber -eq 5) {
            return $Session:Inputs5
        }
        elseif ($InputNumber -eq 6) {
            return $Session:Inputs6
        }
        elseif ($InputNumber -eq 7) {
            return $Session:Inputs7
        }
    }

    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDInput -Title "Purchase Description" -Id "Desc" -Content {
                New-UDInputField -Type 'textarea' -Name "PurchaseDescription" -Placeholder 'I need to purchase this because of that...'
            } -Endpoint {
                param($PurchaseDescription)
        
                # PurchaseDescription validation
                if ($PurchaseDescription -eq $null -or $PurchaseDescription -like "null" -or $PurchaseDescription -eq "") {
                    New-UDInputAction -Toast "Purchase Description missing, description is mandatory, go back and fill it"
                    break
                } 
                Set-UDElement -id "NewProductButton" -Content {         
                    New-UDButton -Text "Add New Product" -OnClick {
                        $Session:InputsInScreen += 1            
                        Set-UDElement -Id "results$Session:InputsInScreen" -Content {
                            Set-InputNumber $Session:InputsInScreen
                        
                        }
                    }
                }
                $Session:FinalDescription = $PurchaseDescription
            }
        }
    }
    
    # TODO: Find a better way to do this, instead of copying the same thing in the different variables.
    # Look...I'm gonna do something here that might be stupid, but it is the only way I can see right now
    # I am doing it like this because each New-UDInputField needs a unique name, and I cannot for the life of me dynamically make a variable in the param() section
    # ---------- START COPYING SAME FORMS IN DIFFERENT VARIABLES

    $Session:Inputs1 = New-UDInput -Title "Product 1" -Id "Form1" -ArgumentList 1 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName1" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL1" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice1" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency1" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount1" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice1" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType1" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge1" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote1" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName1, 
            $ItemURL1,
            $ItemPrice1, 
            $ItemCurrency1,
            $ItemAmount1, 
            $PostagePrice1,
            $PaymentType1,
            $Surcharge1,
            $ItemNote1
        )

        $CurrentItemName = $ItemName1
        $CurrentItemURL = $ItemURL1
        $CurrentItemPrice = $ItemPrice1
        $CurrentItemCurrency = $ItemCurrency1
        $CurrentItemAmount = $ItemAmount1
        $CurrentPostagePrice = $PostagePrice1
        $CurrentPaymentType = $PaymentType1
        $CurrentSurcharge = $Surcharge1
        $CurrentItemNote = $ItemNote1

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }
    $Session:Inputs2 = New-UDInput -Title "Product 2" -Id "Form2" -ArgumentList 2 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName2" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL2" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice2" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency2" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount2" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice2" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType2" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge2" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote2" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName2, 
            $ItemURL2,
            $ItemPrice2, 
            $ItemCurrency2,
            $ItemAmount2, 
            $PostagePrice2,
            $PaymentType2,
            $Surcharge2,
            $ItemNote2
        )

        $CurrentItemName = $ItemName2
        $CurrentItemURL = $ItemURL2
        $CurrentItemPrice = $ItemPrice2
        $CurrentItemCurrency = $ItemCurrency2
        $CurrentItemAmount = $ItemAmount2
        $CurrentPostagePrice = $PostagePrice2
        $CurrentPaymentType = $PaymentType2
        $CurrentSurcharge = $Surcharge2
        $CurrentItemNote = $ItemNote2

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }
    $Session:Inputs3 = New-UDInput -Title "Product 3" -Id "Form3" -ArgumentList 3 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName3" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL3" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice3" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency3" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount3" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice3" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType3" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge3" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote3" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName3, 
            $ItemURL3,
            $ItemPrice3, 
            $ItemCurrency3,
            $ItemAmount3, 
            $PostagePrice3,
            $PaymentType3,
            $Surcharge3,
            $ItemNote3
        )

        $CurrentItemName = $ItemName3
        $CurrentItemURL = $ItemURL3
        $CurrentItemPrice = $ItemPrice3
        $CurrentItemCurrency = $ItemCurrency3
        $CurrentItemAmount = $ItemAmount3
        $CurrentPostagePrice = $PostagePrice3
        $CurrentPaymentType = $PaymentType3
        $CurrentSurcharge = $Surcharge3
        $CurrentItemNote = $ItemNote3

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }
    $Session:Inputs4 = New-UDInput -Title "Product 4" -Id "Form4" -ArgumentList 4 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName4" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL4" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice4" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency4" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount4" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice4" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType4" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge4" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote4" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName4, 
            $ItemURL4,
            $ItemPrice4, 
            $ItemCurrency4,
            $ItemAmount4, 
            $PostagePrice4,
            $PaymentType4,
            $Surcharge4,
            $ItemNote4
        )

        $CurrentItemName = $ItemName4
        $CurrentItemURL = $ItemURL4
        $CurrentItemPrice = $ItemPrice4
        $CurrentItemCurrency = $ItemCurrency4
        $CurrentItemAmount = $ItemAmount4
        $CurrentPostagePrice = $PostagePrice4
        $CurrentPaymentType = $PaymentType4
        $CurrentSurcharge = $Surcharge4
        $CurrentItemNote = $ItemNote4

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }
    $Session:Inputs5 = New-UDInput -Title "Product 5" -Id "Form5" -ArgumentList 5 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName5" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL5" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice5" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency5" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount5" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice5" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType5" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge5" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote5" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName5, 
            $ItemURL5,
            $ItemPrice5, 
            $ItemCurrency5,
            $ItemAmount5, 
            $PostagePrice5,
            $PaymentType5,
            $Surcharge5,
            $ItemNote5
        )

        $CurrentItemName = $ItemName5
        $CurrentItemURL = $ItemURL5
        $CurrentItemPrice = $ItemPrice5
        $CurrentItemCurrency = $ItemCurrency5
        $CurrentItemAmount = $ItemAmount5
        $CurrentPostagePrice = $PostagePrice5
        $CurrentPaymentType = $PaymentType5
        $CurrentSurcharge = $Surcharge5
        $CurrentItemNote = $ItemNote5

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }
    $Session:Inputs6 = New-UDInput -Title "Product 6" -Id "Form6" -ArgumentList 6 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName6" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL6" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice6" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency6" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount6" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice6" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType6" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge6" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote6" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName6, 
            $ItemURL6,
            $ItemPrice6, 
            $ItemCurrency6,
            $ItemAmount6, 
            $PostagePrice6,
            $PaymentType6,
            $Surcharge6,
            $ItemNote6
        )

        $CurrentItemName = $ItemName6
        $CurrentItemURL = $ItemURL6
        $CurrentItemPrice = $ItemPrice6
        $CurrentItemCurrency = $ItemCurrency6
        $CurrentItemAmount = $ItemAmount6
        $CurrentPostagePrice = $PostagePrice6
        $CurrentPaymentType = $PaymentType6
        $CurrentSurcharge = $Surcharge6
        $CurrentItemNote = $ItemNote6

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }
    $Session:Inputs7 = New-UDInput -Title "Product 7" -Id "Form7" -ArgumentList 7 -Content {
        
        New-UDInputField -Type 'textarea' -Name "ItemName7" -Placeholder 'Item Description'
        New-UDInputField -Type 'textarea' -Name "ItemURL7" -Placeholder 'Item URL'
        New-UDInputField -Type 'textbox' -Name "ItemPrice7" -Placeholder 'Item Individual Price'
        New-UDInputField -Type 'select' -Name "ItemCurrency7" -Placeholder 'Item Price Currency' -Values @("AUD", "USD", "CNY")
        New-UDInputField -Type 'textbox' -Name "ItemAmount7" -Placeholder 'Item Amount'
        New-UDInputField -Type 'textbox' -Name "PostagePrice7" -Placeholder 'Final Postage Price (put 0 if none)'
        New-UDInputField -Type 'select' -Name "PaymentType7" -Placeholder "Payment Method" -Values @("Credit Card", "Cash", "Other")
        New-UDInputField -Type 'checkbox' -Name "Surcharge7" -Placeholder "Surcharge?"
        New-UDInputField -Type 'textarea' -Name "ItemNote7" -Placeholder 'Notes (if any)'

    } -Endpoint {
        param(
            $ItemName7, 
            $ItemURL7,
            $ItemPrice7, 
            $ItemCurrency7,
            $ItemAmount7, 
            $PostagePrice7,
            $PaymentType7,
            $Surcharge7,
            $ItemNote7
        )

        $CurrentItemName = $ItemName7
        $CurrentItemURL = $ItemURL7
        $CurrentItemPrice = $ItemPrice7
        $CurrentItemCurrency = $ItemCurrency7
        $CurrentItemAmount = $ItemAmount7
        $CurrentPostagePrice = $PostagePrice7
        $CurrentPaymentType = $PaymentType7
        $CurrentSurcharge = $Surcharge7
        $CurrentItemNote = $ItemNote7

        # Time to do some validation on New-UDInputField because the UniversalDashboard doesn't support [PatternValidation] yet (for New-UDInputField)
        # I did try to use switch here instead of many Ifs, but I couldn't properly break the outer loop of the switch???

        # ItemName validation
        if ($CurrentItemName -eq $null -or $CurrentItemName -like "null" -or $CurrentItemName -eq "") {
            New-UDInputAction -Toast "Item Description missing, item not added, go back and fill it"
            break
        }

        #ItemURL validation
        if ($CurrentItemURL -eq $null -or $CurrentItemURL -like "null" -or $CurrentItemURL -eq "") {
            New-UDInputAction -Toast "Item URL missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemURL -notmatch '^https?://' ) {
            New-UDInputAction -Toast "Item URL does not start with HTTP or HTTPS, item not added, provide a proper URL"
            break
        }

        #ItemPrice Validation
        if ($CurrentItemPrice -eq $null -or $CurrentItemPrice -like "null" -or $CurrentItemPrice -eq "") {
            New-UDInputAction -Toast "Item Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemPrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Item Price is not a valid number, item not added, use a proper price"
            break
        }

        #ItemAmount Validation
        if ($CurrentItemAmount -eq $null -or $CurrentItemAmount -like "null" -or $CurrentItemAmount -eq "") {
            New-UDInputAction -Toast "Item Amount missing, item not added, go back and fill it"
            break
        }
        if ($CurrentItemAmount -notmatch '^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$') {
            New-UDInputAction -Toast "Item Amount is not a number, item not added, go back and fill it"
            break
        }

        #PostagePrice Validation
        if ($CurrentPostagePrice -eq $null -or $CurrentPostagePrice -like "null" -or $CurrentPostagePrice -eq "") {
            New-UDInputAction -Toast "Postage Price missing, item not added, go back and fill it"
            break
        }
        if ($CurrentPostagePrice -notmatch '^\d+(,\d{3})*(\.\d{1,2})?$') {
            New-UDInputAction -Toast "Postage Price is not a number, item not added, go back and fill it"
            break
        }
                
        # Get the last number of the index
        if ($Session:FinalArray.count -eq 0) {
            $Session:LastIndex = 0
        }
        else {
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }  
     
        # Add the current product if it doesn't exist
        if (($ArgumentList[0] -gt $Session:LastIndex -or $ArgumentList[0] -lt $Session:LastIndex) -and $Session:FinalArray.Index -notcontains $ArgumentList[0]) {
            $NewValues = [PSCustomObject]@{
                Index        = $ArgumentList[0]
                ItemName     = $CurrentItemName
                ItemURL      = $CurrentItemURL
                ItemPrice    = $CurrentItemPrice
                ItemAmount   = $CurrentItemAmount
                ItemCurrency = $CurrentItemCurrency
                PostagePrice = $CurrentPostagePrice
                PaymentType  = $CurrentPaymentType
                Surcharge    = $CurrentSurcharge
                ItemNote     = $CurrentItemNote                   
            }
            $NewValues | ForEach-Object {
                [array]$Session:FinalArray += $_
            }
            # Just making sure we have he latest index refreshed
            $Session:LastIndex = $Session:FinalArray[-1].Index
        }
        else {
                
            # Update the current product if it exists
            [array]$Session:FinalArray | ForEach-Object {     
                if ($_.Index -eq $ArgumentList[0]) {
                    $_.ItemName = $CurrentItemName
                    $_.ItemURL = $CurrentItemURL
                    $_.ItemPrice = $CurrentItemPrice
                    $_.ItemAmount = $CurrentItemAmount
                    $_.ItemCurrency = $CurrentItemCurrency
                    $_.PostagePrice = $CurrentPostagePrice
                    $_.PaymentType = $CurrentPaymentType
                    $_.Surcharge = $CurrentSurcharge
                    $_.ItemNote = $CurrentItemNote  
                } 
            }  
        }
        # Just making sure we have he latest index refreshed
        $Session:LastIndex = $Session:FinalArray[-1].Index

        New-UDInputAction -Toast "Added to cart succesfully!"

        # Output the final array to a file
        #$Session:FinalArray | Sort-Object Index | ConvertTo-Json -depth 5 | out-file "C:\inetpub\wwwroot\ITPurchaseForm\testdash2.json"
            
        Set-UDElement -id "CartButton" -Content {
            New-UDButton -Text "Continue to Cart" -OnClick {
                Invoke-UDRedirect -Url "/Cart"
            } 
        }
    }

    # ---------- FINISh COPYING SAME FORMS IN DIFFERENT VARIABLES

        
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results1"
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results2"
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results3"
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results4"
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results5"
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results6"
        }
    }
    New-UDRow -Columns {
        New-UDColumn -Size 12 {
            New-UDElement -Tag "div" -Id "results7"
        }
    }

    $Session:InputsInScreen = 0

    New-UDRow -Columns {
        New-UDColumn -Size 2 {
            New-UDElement -tag "div" -id "NewProductButton"
        }
        New-UDColumn -Size 2 {
            New-UDElement -tag "div" -id "CartButton"
        }
    }

}

$Page3 = New-UDPage -Url "/Cart/" -Endpoint {
    param()

    $ApiKey = get-content "C:\inetpub\wwwroot\ITPurchaseForm\CurrApiKey.key"

    $USDConversion = Invoke-RestMethod -uri "https://free.currconv.com/api/v7/convert?q=USD_AUD&apiKey=$ApiKey&compact=ultra"
    $CNYConversion = Invoke-RestMethod -uri "https://free.currconv.com/api/v7/convert?q=CNY_AUD&apiKey=$ApiKey&compact=ultra"
    
    $USDConv = $USDConversion.USD_AUD
    $CNYConv = $CNYConversion.CNY_AUD

    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDGrid -Title "List of Products:" -Headers @("Index", "Item Name", "URL", "Price", "Amount", "Currency", "Postage Price", "Payment Type", "Notes", "Remove") -Properties @("Index", "ItemName", "ItemURL", "ItemPrice", "ItemAmount", "ItemCurrency", "PostagePrice", "PaymentType", "ItemNote") -Endpoint {
                $Session:FinalArray | ForEach-Object {
                    [PSCustomObject]@{
                        Index        = $_.Index
                        ItemName     = $_.ItemName
                        ItemURL      = $_.ItemURL
                        ItemPrice    = $_.ItemPrice
                        ItemAmount   = $_.ItemAmount
                        ItemCurrency = $_.ItemCurrency
                        PostagePrice = $_.PostagePrice
                        PaymentType  = $_.PaymentType
                        ItemNote     = $_.ItemNote  
                    }
                } | Out-UDGridData 
            }  
        }
    }

    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDInput -Title "Actual Grand Total (paste the correct grand total of the purchase here, sum of all products)" -SubmitText "Send for Approval" -id "GrandTotalForm" -Content {
                New-UDInputField -Type "select" -Name "GrandTotalCurrency" -Placeholder "Currency" -Values @("AUD", "USD", "CNY")
                New-UDInputField -Type "textbox" -Name "GrandTotalPrice" -Placeholder "Grand Total"
                New-UDInputField -Type "textbox" -Name "OwnEmail" -Placeholder "Your Own Email (to be CCed in final email)"
                New-UDInputField -Type "textbox" -Name "OwnName" -Placeholder "Your Own Name (to be CCed in final email)"
            } -Endpoint {
                param(
                    $GrandTotalCurrency,
                    $GrandTotalPrice,
                    $OwnEmail,
                    $OwnName
                )

                # GrandTotalPrice validation
                if ($GrandTotalPrice -eq $null -or $GrandTotalPrice -like "null" -or $GrandTotalPrice -eq "") {
                    New-UDInputAction -Toast "Grand Total missing, not sent for approval, go back and fill it"
                    break
                }

                # OwnEmail validation
                if ($OwnEmail -eq $null -or $OwnEmail -like "null" -or $OwnEmail -eq "") {
                    New-UDInputAction -Toast "Your Own Email missing, not sent for approval, go back and fill it"
                    break
                }
                if ($OwnEmail -notmatch '^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$' ) {
                    New-UDInputAction -Toast "Your Own Email is not a valid email, not sent for approval, provide a proper email"
                    break
                }

                # OwnName Validation
                if ($OwnName -eq $null -or $OwnName -like "null" -or $OwnName -eq "") {
                    New-UDInputAction -Toast "Your Own Name missing, not sent for approval, go back and fill it"
                    break
                }

                $Session:ExternalCurrencies = 0
                $Session:FinalGrandTotal = $GrandTotalPrice
                $Session:CurrencyGrandTotal = $GrandTotalCurrency

                if ($GrandTotalCurrency -eq "USD") {
                    $Session:ExternalCurrencies += 1
                    $Session:ConvertedGrandTotal = [double]$Session:FinalGrandTotal * $USDConv 
                }
                elseif ($GrandTotalCurrency -eq "CNY") {
                    $Session:ExternalCurrencies += 1
                    $Session:ConvertedGrandTotal = [double]$Session:FinalGrandTotal * $CNYConv 
                }
                else {
                    $Session:ConvertedGrandTotal = [double]$Session:FinalGrandTotal
                }
                $Session:ConvertedGrandTotal = "{0:c}" -f [double]$Session:ConvertedGrandTotal
                $Session:FinalGrandTotal = "{0:c}" -f [double]$Session:FinalGrandTotal

                $Session:FinalArray | ForEach-Object {
                    if ($_.ItemCurrency -like "USD" -or $_.ItemCurrency -like "CNY") {
                        $Session:ExternalCurrencies += 1
                    }
                    $bodyhtml1 += "<p><b>Item Description:</b> " + $_.ItemName + "<br>" 
                    $bodyhtml1 += "<b>Item URL: </b><a href=" + [string]$_.ItemURL + ">" + $_.ItemURL + "</a><br>" 
                    $bodyhtml1 += "<b>Item Unitary Price: </b>" + $_.ItemCurrency + "{0:c}" -f [double]$_.ItemPrice + "<br>" 
                    $bodyhtml1 += "<b>Item Amount: </b>" + $_.ItemAmount + "<br>" 
                    if ($_.PostagePrice -eq 0) {
                        $bodyhtml1 += "<b>Postage Price:</b> Free &#9989;<br>" 
                    }
                    else {
                        $bodyhtml1 += "<b>Postage Price:</b> " + $_.ItemCurrency + "{0:c}" -f [double]$_.PostagePrice + "<br>" 
                    }
                    if ($_.PaymentType -eq "Credit Card") {
                        $bodyhtml1 += "<b>Payment Type:</b> " + $_.PaymentType + " &#128179; <br>"
                    }
                    elseif ($_.PaymentType -eq "Cash") {
                        $bodyhtml1 += "<b>Payment Type:</b> " + $_.PaymentType + " &#128184; <br>"
                    }
                    else {
                        $bodyhtml1 += "<b>Payment Type:</b> " + $_.PaymentType + "<br>"
                    }  
                    if ($_.Surcharge -eq $true) {
                        $bodyhtml1 += "<b>&#9989; Surcharge </b><br>"
                    }
                    else {
                        $bodyhtml1 += "<b>&#10062; No Surcharge </b><br>"
                    }        
                    $bodyhtml1 += "<b>Sub Total:</b> " + $_.ItemCurrency + "{0:c}" -f (([double]$_.ItemPrice * [double]$_.ItemAmount) + [double]$_.PostagePrice) + "<br>" 
                    if ($_.ItemNote -notlike "null") {
                        $bodyhtml1 += "<b>Notes:</b> " + $_.ItemNote + "<br></p>" 
                    }
            
                }
                if ($Session:ExternalCurrencies -gt 0) {
                    $ExpectedPrice = "<i>Expected Grand Total (in AUD, based on Grand Total above, for reference only - some vendors might have their own conversion rate): AUD" + "{0:c}" -f $Session:ConvertedGrandTotal + "</i><br>"
                }
                else {
                    $ExpectedPrice = ""
                }
        

                $bodyhtml2 = @"
    <div style='font-family:Calibri'>
    <p><h3>To SSWSysAdmins,</h3>
    $Session:FinalDescription
    <br>
    $bodyhtml1
    <br>
    <h3>Grand Total: $Session:CurrencyGrandTotal$Session:FinalGrandTotal</b></h3>
    $ExpectedPrice
    <br>$OwnName</p>
    <p>-- Powered by SSW.SSWITPurchaseRequest<br> Server: $env:computername </p></div>
"@
    
                Send-MailMessage -From "info@ssw.com.au" -to $OwnEmail -Subject "Purchase Please - Request for" -Body $bodyhtml2 -SmtpServer "ssw-com-au.mail.protection.outlook.com" -BodyAsHtml
                New-UDInputAction -Toast "Email sent to SSWITPurchaseRequest@ssw.zendesk.com!"
            }
        }
    }


    $Session:FinalArray | ForEach-Object {

        if ($_.ItemCurrency -eq "USD") {
            $ConvertedItemPrice = [double]$_.ItemPrice * $USDConv 
            $ConvertedPostage = [double]$_.PostagePrice * $USDConv 
        }
        elseif ($_.ItemCurrency -eq "CNY") {
            $ConvertedItemPrice = [double]$_.ItemPrice * $CNYConv
            $ConvertedPostage = [double]$_.PostagePrice * $CNYConv 
        }
        elseif ($_.ItemCurrency -eq "AUD") {
            $ConvertedItemPrice = [double]$_.ItemPrice
            $ConvertedPostage = [double]$_.PostagePrice

        }

        [double]$FinalItemPrice += ([double]$ConvertedItemPrice * [double]$_.ItemAmount) + [double]$ConvertedPostage
    } 


    New-UDRow -Endpoint {
        New-UDColumn -Size 4 -Endpoint {
            New-UDCounter -Title "Expected AUD Grand Total (reference only)" -AutoRefresh -Format '$0,0.00' -RefreshInterval 3 -Endpoint {
                [double]$FinalItemPrice
            }
        }
        New-UDColumn -Size 4 -Endpoint {
            New-UDCounter -Title "1 USD to AUD Rate" -AutoRefresh -Format '$0,0.00' -RefreshInterval 7 -Endpoint {
                [double]$USDConversion.USD_AUD
            }
        }
        New-UDColumn -Size 4 -Endpoint {
            New-UDCounter -Title "1 CNY to AUD Rate" -AutoRefresh -Format '$0,0.00' -RefreshInterval 7 -Endpoint {
                [double]$CNYConversion.CNY_AUD
            }
        }
    }
}


$Dashboard = New-UDDashboard -theme $theme -Pages @($Page1, $Page2, $Page3) -Title "SSW IT Purchase Request" 
Start-UDDashboard -port 10001 -Dashboard $Dashboard -Wait
