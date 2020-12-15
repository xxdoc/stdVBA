Attribute VB_Name = "stdPerformanceTests"

Const C_MAX as long = 1000
Sub testAll()
    Test.Topic "stdPerformance"
    
    'Measurement keys 1
    With stdPerformance.Measure("Test1")
    End With
    Test.Assert "MeasurementKeys 1", Join(stdPerformance.MeasurementKeys,";") = "Test1"
    
    'Measurement keys 2
    With stdPerformance.Measure("Test2")
    End With
    Test.Assert "MeasurementKeys 2", Join(stdPerformance.MeasurementKeys,";") = "Test1;Test2"

    With stdPerformance.measure("#1 Select and set")
        For i = 1 to C_MAX
            cells(1,1).select
            selection.value = "hello"
        Next
    End With

    With stdPerformance.measure("#2 Set directly")
        For i = 1 to C_MAX
            cells(1,1).value = "hello"
        next
    End With

    'GetMeasurement
    Test.Assert "GetMeasurement", stdPerformance.GetMeasurement("#1 Select and set") > 0
    
    'Clear all measurements
    stdPerformance.MeasurementsClear

    'Remove items removes all keys
    Test.Assert "Clear removes items", ubound(stdPerformance.MeasurementKeys) - lbound(stdPerformance.MeasurementKeys) + 1 = 0

    'If key not found measurment is empty?
    Test.Assert "GetMeasurement null", stdPerformance.GetMeasurement("#1 Select and set") = Empty

    'Optimise testing
    Application.ScreenUpdating = true
    Application.EnableEvents = true
    With stdPerformance.Optimise()
        Test.Assert "Optimise - 1a. ScreenUpdating=False", Not Application.ScreenUpdating
        Test.Assert "Optimise - 2a. EnableEvents=False", Not Application.EnableEvents
    End With
    Test.Assert "Optimise - 1b. ScreenUpdating restored", Application.ScreenUpdating
    Test.Assert "Optimise - 2b. EnableEvents restored", Application.EnableEvents
end sub