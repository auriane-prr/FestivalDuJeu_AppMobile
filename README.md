# FestivalduJeu - Gestion des bénévoles
## À propos du projet
Ce projet a été développé dans le cadre de notre quatrième année d'études d'ingénierie informatique à Polytech Montpellier, en collaboration avec Margaux Thirion (https://github.com/MargauxThirion). L'objectif principal de FestivalduJeu est de fournir une solution pratique et efficace pour gérer les bénévoles lors du Festival du Jeu à Montpellier.

FestivalduJeu est une application mobile qui offre aux bénévoles la possibilité de s'inscrire à différents stands et zones selon leurs disponibilités. Les bénévoles peuvent choisir un seul poste par créneau horaire ou opter pour une flexibilité, auquel cas l'attribution des postes est gérée par l'administrateur via une application web dédiée.

## Architecture
L'architecture de FestivalduJeu repose sur une approche client-serveur classique :

Client : Gère l'interface utilisateur et les interactions avec les utilisateurs. Les bénévoles utilisent l'application mobile pour s'inscrire aux différents stands et zones.
Serveur : Responsable de la logique métier, de la gestion des données et des interactions avec la base de données. Le serveur traite les requêtes HTTP envoyées par l'application client.
Vous pouvez trouver le backend ici : https://github.com/MargauxThirion/IG4-Benevole-Back.git

## Fonctionnalités
Inscription des bénévoles : Permet aux bénévoles de s'inscrire et de choisir leurs créneaux horaires et zones de préférence.
Gestion de la flexibilité : Les bénévoles peuvent se déclarer flexibles, laissant à l'administrateur le soin de les assigner à des postes selon les besoins.
Interface administrateur : Accessible via une application web, elle permet de gérer les affectations des bénévoles et d'avoir une vue d'ensemble de l'organisation des volontaires.
