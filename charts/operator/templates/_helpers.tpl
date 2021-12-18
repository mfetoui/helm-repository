{{/* vim: set filetype=mustache: */}}

{{/* STARTX Cluster RBAC helpers */}}

{{/* Common labels */}}
{{- define "operator.labels" -}}
{{ include "startx.labelsCommon" . }}
app.kubernetes.io/instance: {{ include "startx.appName" . | quote }}
{{- end -}}

{{/* Common operator annotations */}}
{{- define "operator.annotations" -}}
{{- include "startx.annotationsInfra" . -}}
{{- end -}}

{{/* Common operator note */}}
{{- define "operator.notes" -}}
-- Subscription --------------------
{{- if .subscription }}{{- if .subscription.enabled }}
{{- $name := .subscription.name }}
{{- $namespace := .operatorGroup.namespace }}
{{- $version := .subscription.version }}
         name : {{ $name }}
    namespace : {{ $namespace }}
{{- with .subscription.operator }}
{{- $operator := . }}
      channel : {{ .channel | default "latest" }}
         name : {{ .name | default $name }}
{{- with .source }}
       source : {{ .name | default "redhat-operators" }}
    source NS : {{ .namespace | default "openshift-marketplace" }}
{{- end }}
          CSV : {{ .csv }}.v{{ $version }}
{{- end }}
{{- else }}
 subscription : disabled
{{- end }}
{{- else }}
 subscription : disabled
{{- end }}

-- Operator group ------------------
{{- if .operatorGroup }}{{- if .operatorGroup.enabled }}
{{- $name := .operatorGroup.name | default .subscription.name }}
{{- $namespace := .operatorGroup.namespace | default .subscription.namespace }}
{{- $providedAPIs := .operatorGroup.providedAPIs }}
         name : {{ $name }}
    namespace : {{ $namespace }}
 providedAPIs : {{ $providedAPIs }}
{{- if .operatorGroup.target }}
  {{- if eq .operatorGroup.target "all-ns" }}
    target NS : ALL
  {{- else }}
    target NS : {{ $namespace }}
  {{- end }}
{{- else }}
    target NS : {{ $namespace }}
{{- end }}
{{- else }}
OperatorGroup : disabled
{{- end }}
{{- else }}
OperatorGroup : disabled
{{- end }}
{{- end -}}