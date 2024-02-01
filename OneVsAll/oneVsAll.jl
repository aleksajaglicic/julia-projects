using GLM
using CSV
using DataFrames
using Lathe
using StatsModels

data = DataFrame(CSV.File("drvo.csv"))

bor = "Bor"
jasen = "Jasen"
bukva = "Bukva"

insertcols!(data, 5, :Vrsta => 0.0, makeunique = false)

#Value
for i in 1:size(data)[1]
    if data[i, :vrsta] == bor
        data[i, :Vrsta] = 0.3
    elseif data[i, :vrsta] == jasen
        data[i, :Vrsta] = 0.6
    elseif data[i, :vrsta] == bukva
        data[i, :Vrsta] = 0.9
    end
end

data = select!(data, Not(:vrsta))
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, 0.80)
fm = @formula(Vrsta ~ visina + sirina)

#Separate classes
function separate(dataTrain, fst, snd, thd)
    newData = deepcopy(dataTrain)
    for i in 1:size(newData)[1]
        if newData[i, :Vrsta] == fst
            newData[i, :Vrsta] = 1.0
        elseif newData[i, :Vrsta] == thd
            newData[i, :Vrsta] = 0.0
        elseif newData[i, :Vrsta] == snd
            newData[i, :Vrsta] = 0.0
        end
    end
    return newData
end

#Train Setovi
dataTrain_1 = separate(dataTrain, 0.3, 0.9, 0.6)
dataTrain_2 = separate(dataTrain, 0.6, 0.3, 0.9)
dataTrain_3 = separate(dataTrain, 0.9, 0.6, 0.3)

#Regress Setovi
setGLM_1 = glm(fm, dataTrain_1, Binomial(), ProbitLink())
setGLM_2 = glm(fm, dataTrain_2, Binomial(), ProbitLink())
setGLM_3 = glm(fm, dataTrain_3, Binomial(), ProbitLink())

#Predict Setovi
borPredict = predict(setGLM_1, dataTest)
jasenPredict = predict(setGLM_2, dataTest)
bukvaPredict = predict(setGLM_3, dataTest)

#Class Setovi
dataPredictClass1 = deepcopy(borPredict)
dataPredictClass2 = deepcopy(jasenPredict)
dataPredictClass3 = deepcopy(bukvaPredict)

#One VS All
function oneVsAll(dataTest, borPredict, jasenPredict, bukvaPredict)
    dataPredictTestClass = repeat(0:0, size(dataTest)[1])
    test = [0, 0, 0]

    for i in 1:length(dataPredictTestClass)
        if borPredict[i] > 0.0 && borPredict[i] < 0.3
            test[1] += 1
        elseif jasenPredict[i] > 0.3 && jasenPredict[i] < 0.6
            test[2] += 1
        elseif bukvaPredict[i] > 0.6
            test[3] += 1
        end
    end

    if ((test[1] / sum(test) < test[2] / sum(test)) && (test[2] / sum(test) > test[3] / sum(test)))
        dataPredictTestClass = test[2] / sum(test)
        Ispis = "Jasen se pojavljuje sa procentom $dataPredictedTestClass vise od ostalih"
    elseif (test[2] / sum(test) < test[1] / sum(test) && test[1] / sum(test) > test[3] / sum(test))
        dataPredictTestClass = test[1] / sum(test)
        Ispis = "Bor se pojavljuje sa procentom $dataPredictedTestClass vise od ostalih"
    else
        #Drugi nacin: (test[2] / sum(test) < test[3] / sum(test) && test[3] / sum(test) > test[1] / sum(test))
        dataPredictTestClass = test[3] / sum(test)
        Ispis = "Bukva se pojavljuje sa procentom $dataPredictedTestClass vise od ostalih"
    end
    return dataPredictTestClass, Ispis
end

#Sensitivity Test
function sensitivity(FNTest, TPTest)
    sensitivityTest = TPTest / (TPTest + FNTest)
    return sensitivityTest
end

dataPredictedTestClass, Ispis = oneVsAll(dataTest, borPredict, jasenPredict, bukvaPredict)

data = select!(data, Not(:id))
display(data)

#Confusion Matrix
function matrix(data, dataPredictedTestClass)
    FPTest = 0
    FNTest = 0
    TPTest = 0
    TNTest = 0
    for i in 1:length(dataPredictedTestClass)
        if round(dataPredictedTestClass[i], digits = 1) == data.Vrsta[i]
            TPTest += 1
        elseif round(dataPredictedTestClass[i], digits = 1) == 0.3 && data[i, :Vrsta] != 0.3
            FPTest += 1
        elseif round(dataPredictedTestClass[i], digits = 1) != 0.3 && data[i, :Vrsta] == 0.3
            FNTest += 1
        elseif round(dataPredictedTestClass[i], digits = 1) == 0.6 && data[i, :Vrsta] != 0.6
            FPTest += 1
        elseif round(dataPredictedTestClass[i], digits = 1) != 0.6 && data[i, :Vrsta] == 0.6
            FNTest += 1
        elseif round(dataPredictedTestClass[i], digits = 1) == 0.9 && data[i, :Vrsta] != 0.9
            FPTest += 1
        elseif round(dataPredictedTestClass[i], digits = 1) != 0.9 && data[i, :Vrsta] == 0.9
            FNTest += 1
        else
            TNTest += 1
        end
    end
    return TPTest, FPTest, FNTest, TNTest
end

#Class Matrices
TP1, FP1, FN1, TN1 = matrix(dataTest, dataPredictClass1)
TP2, FP2, FN2, TN2 = matrix(dataTest, dataPredictClass2)
TP3, FP3, FN3, TN3 = matrix(dataTest, dataPredictClass3)

#Class Sensitivity
sensitivity_1 = sensitivity(TP1, FN1)
sensitivity_2 = sensitivity(TP2, FN2)
sensitivity_3 = sensitivity(TP3, FN3)

TPTest = TP1 + TP2 + TP3
TNTest = TN1 + TN2 + TN3
FPTest = FP1 + FP2 + FP3
FNTest = FN1 + FN2 + FN3

#System Accuracy
accuracyTest = accuracyTest = (TPTest + TNTest) / (TPTest + TNTest + FPTest + FNTest)

println("\n")
display(Ispis)
println("\n")
println("SensitivityTest za prvu klasu je $sensitivity_1")
println("\n")
println("SensitivityTest za drugu klasu je $sensitivity_2")
println("\n")
println("SensitivityTest za trecu klasu je $sensitivity_3")
println("\n")
println("Preciznost sistema je $accuracyTest")