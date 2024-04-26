FROM  openjdk:8
LABEL "MAINTAINER"="tamu.deepak02@gmail.com"
ADD jarstaging/com/valaxy/demo-workshop/2.1.3/demo-workshop-2.1.3.jar nikutrend.jar
ENTRYPOINT ["java", "-jar", "nikutrend.jar"]
