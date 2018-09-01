
FROM openjdk:8-jdk
MAINTAINER Amit Kumar Sharma "amit.official@gmail.com"

EXPOSE 8080

ENV TOMCAT_VERSION 8.0.38
ENV ACTIVITI_VERSION 5.22.0

# Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz && \
	tar xzf /tmp/catalina.tar.gz -C /opt && \
	ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
	rm /tmp/catalina.tar.gz && \
	rm -rf /opt/tomcat/webapps/examples && \
	rm -rf /opt/tomcat/webapps/docs

# To install jar files first we need to deploy war files manually
RUN wget https://github.com/Activiti/Activiti/releases/download/activiti-${ACTIVITI_VERSION}/activiti-${ACTIVITI_VERSION}.zip -O /tmp/activiti.zip && \
 	unzip /tmp/activiti.zip -d /opt/activiti && \
	unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-explorer.war -d /opt/tomcat/webapps/activiti-explorer && \
	unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-rest.war -d /opt/tomcat/webapps/activiti-rest && \
	rm -f /tmp/activiti.zip

# Disable demo data creation in activiti-rest app
# RUN sed 's/create.demo.users=true/create.demo.users=false/g' -i /opt/tomcat/webapps/activiti-rest/WEB-INF/classes/engine.properties
RUN sed 's/create.demo.definitions=true/create.demo.definitions=false/g' -i /opt/tomcat/webapps/activiti-rest/WEB-INF/classes/engine.properties
RUN sed 's/create.demo.models=true/create.demo.models=false/g' -i /opt/tomcat/webapps/activiti-rest/WEB-INF/classes/engine.properties
RUN sed 's/create.demo.reports=true/create.demo.reports=false/g' -i /opt/tomcat/webapps/activiti-rest/WEB-INF/classes/engine.properties

# Disable demo data creation in activiti-explorer app
# RUN sed 's/create.demo.users=true/create.demo.users=false/g' -i /opt/tomcat/webapps/activiti-explorer/WEB-INF/classes/engine.properties
RUN sed 's/create.demo.definitions=true/create.demo.definitions=false/g' -i /opt/tomcat/webapps/activiti-explorer/WEB-INF/classes/engine.properties
RUN sed 's/create.demo.models=true/create.demo.models=false/g' -i /opt/tomcat/webapps/activiti-explorer/WEB-INF/classes/engine.properties
RUN sed 's/create.demo.reports=true/create.demo.reports=false/g' -i /opt/tomcat/webapps/activiti-explorer/WEB-INF/classes/engine.properties

# Add mysql connector to application
ADD ./jdbc/mssql-jdbc-7.0.0.jre8.jar /opt/tomcat/webapps/activiti-rest/WEB-INF/lib/ 
ADD ./jdbc/mssql-jdbc-7.0.0.jre8.jar /opt/tomcat/webapps/activiti-explorer/WEB-INF/lib/


# Add roles
ADD assets /assets
RUN cp /assets/config/tomcat/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

CMD ["/assets/init"]

