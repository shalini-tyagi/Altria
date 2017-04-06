<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>File_Type</fullName>
        <field>File_Type__c</field>
        <formula>RIGHT(File_Name__c , LEN(File_Name__c) - FIND(&quot;.&quot;,File_Name__c ))</formula>
        <name>File Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update File Type</fullName>
        <actions>
            <name>File_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Attachment_Detail__c.File_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
