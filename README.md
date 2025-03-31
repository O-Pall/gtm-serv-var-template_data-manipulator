# Data Manipulator pour GTM Server-Side

Variable template pour Google Tag Manager Server-Side permettant de manipuler et transformer des données facilement.

⚠️ **AVERTISSEMENT** ⚠️

Bien que ce template ait été rigoureusement testé, le nombre de combinaisons possibles entre les types de données, les conditions et les transformations est considérable. Il est de votre responsabilité de :
- Tester exhaustivement le template avec VOS données
- Vérifier chaque cas d'utilisation spécifique à votre configuration
- Valider le comportement dans un environnement de préproduction
- Ne pas déployer en production sans tests préalables approfondis

## Fonctionnalités

### Mode Simple
- Accès direct à une variable
- Accès aux propriétés d'un objet via notation pointée (ex: "user.profile.id")
- Conversion automatique vers le type souhaité

### Mode Avancé
- Règles de transformation conditionnelles
- Plusieurs types de comparaison :
  - Égal à
  - Contient
  - Expression régulière (Regex)
  - Supérieur à
  - Inférieur à
- Conversion automatique vers le type souhaité pour chaque règle

## Utilisation

### Mode Simple

1. Sélectionnez "Simple" dans le type de manipulation
2. Configurez :
   - Variable d'entrée : Votre variable ou objet
   - Clé d'accès (optionnel) : Chemin d'accès si c'est un objet (ex: "user.id")
   - Format de retour : string, integer, boolean, floating

Exemple :
```javascript
// Entrée
inputVariable: { user: { isNew: true } }
accessKey: "user.isNew"
returnFormat: "string"

// Sortie
"true"
```

### Mode Avancé

1. Sélectionnez "Avancé" dans le type de manipulation
2. Configurez votre variable d'entrée
3. Ajoutez une ou plusieurs règles de transformation :
   - Type de condition
   - Valeur à comparer
   - Valeur de retour
   - Type de retour

Exemple :
```javascript
// Configuration
inputVariable: "status_123"
Règle 1:
  - Condition: "contains"
  - Valeur: "123"
  - Retour: "1"
  - Type: "integer"

// Sortie
1
```

## Types de Retour Supportés

- `string` : Texte
- `integer` : Nombre entier
- `floating` : Nombre décimal
- `boolean` : true/false

Pour les booléens, les valeurs suivantes sont reconnues :
- Vrai : "1", "true", "oui", "yes", "on", etc.
- Faux : "0", "false", "non", "no", "off", etc.

## Cas d'Utilisation

1. Uniformisation des données :
```javascript
// Entrée : différents formats de "nouveau client"
"true" ou "1" ou "yes" → true (boolean)
```

2. Transformation conditionnelle :
```javascript
// Entrée : "user_premium"
Si contient "premium" → retourner "high_value"
```

3. Extraction de données :
```javascript
// Entrée : { user: { orders: { count: "123" } } }
Accès : "user.orders.count"
Type : integer
// Sortie : 123
```

## Currently working tests

Provided in @./mocks.js
