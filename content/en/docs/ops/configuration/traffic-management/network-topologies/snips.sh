#!/bin/bash
# shellcheck disable=SC2034,SC2153,SC2155,SC2164

# Copyright Istio Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

####################################################################################################
# WARNING: THIS IS AN AUTO-GENERATED FILE, DO NOT EDIT. PLEASE MODIFY THE ORIGINAL MARKDOWN FILE:
#          docs/ops/configuration/traffic-management/network-topologies/index.md
####################################################################################################

! read -r -d '' snip_configuring_network_topologies_1 <<\ENDSNIP
spec:
  meshConfig:
    defaultConfig:
      gatewayTopology:
        numTrustedProxies: <VALUE>
        forwardClientCertDetails: <ENUM_VALUE>
ENDSNIP

! read -r -d '' snip_configuring_network_topologies_2 <<\ENDSNIP
...
  metadata:
    annotations:
      "proxy.istio.io/config": '{"gatewayTopology" : { "numTrustedProxies": <VALUE>, "forwardClientCertDetails": <ENUM_VALUE> } }'
ENDSNIP

snip_install_num_trusted_proxies_two() {
cat <<EOF > topology.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  meshConfig:
    defaultConfig:
      gatewayTopology:
        numTrustedProxies: 2
EOF
istioctl install -f topology.yaml
}

snip_create_httpbin_namespace() {
kubectl create namespace httpbin
}

! read -r -d '' snip_create_httpbin_namespace_out <<\ENDSNIP
namespace/httpbin created
ENDSNIP

snip_label_httpbin_namespace() {
kubectl label --overwrite namespace httpbin istio-injection=enabled
}

! read -r -d '' snip_label_httpbin_namespace_out <<\ENDSNIP
namespace/httpbin labeled
ENDSNIP

snip_apply_httpbin() {
kubectl apply -n httpbin -f samples/httpbin/httpbin.yaml
}

snip_deploy_httpbin_gateway() {
kubectl apply -n httpbin -f samples/httpbin/httpbin-gateway.yaml
}

snip_export_gateway_url() {
export GATEWAY_URL=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
}

snip_curl_xff_headers() {
curl -H 'X-Forwarded-For: 56.5.6.7, 72.9.5.6, 98.1.2.3' "$GATEWAY_URL"/get?show_env=true
}

! read -r -d '' snip_curl_xff_headers_out <<\ENDSNIP
{
  "args": {
    "show_env": "true"
  },
  "headers": {
    ...
    "X-Envoy-External-Address": "72.9.5.6",
    ...
    "X-Forwarded-For": "56.5.6.7, 72.9.5.6, 98.1.2.3,$GATEWAY_URL",
    ...
  },
  ...
}
ENDSNIP

! read -r -d '' snip_configuring_xforwardedclientcert_headers_1 <<\ENDSNIP
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  meshConfig:
    defaultConfig:
      gatewayTopology:
        forwardClientCertDetails: <ENUM_VALUE>
ENDSNIP

! read -r -d '' snip_proxy_protocol_1 <<\ENDSNIP
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: proxy-protocol
  namespace: istio-system
spec:
  configPatches:
  - applyTo: LISTENER
    patch:
      operation: MERGE
      value:
        listener_filters:
        - name: envoy.listener.proxy_protocol
        - name: envoy.listener.tls_inspector
  workloadSelector:
    labels:
      istio: ingressgateway
ENDSNIP
