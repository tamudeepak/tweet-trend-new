FROM  openjdk:8
LABEL "MAINTAINER"="tamu.deepak02@gmail.com"
ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar nikutrend.jar
ENTRYPOINT ["java", "-jar", "nikutrend.jar"]
